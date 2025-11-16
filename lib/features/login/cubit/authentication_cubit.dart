import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/generated/lib/src/model/paperless_auth_token_request.dart';
import 'package:paperless_api/generated/lib/src/model/user.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/constants.dart';
import 'package:paperless_mobile/core/interceptor/language_header.interceptor.dart';
import 'package:paperless_mobile/core/model/info_message_exception.dart';
import 'package:paperless_mobile/core/security/session_manager.dart';
import 'package:paperless_mobile/core/security/session_manager_impl.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/core/service/file_service.dart';
import 'package:paperless_mobile/core/store/encrypted_local_store.dart';
import 'package:paperless_mobile/core/store/local_store.dart';
import 'package:paperless_mobile/core/store/slices/local_user_account.dart';
import 'package:paperless_mobile/core/store/slices/local_user_data.dart';
import 'package:paperless_mobile/core/store/slices/user_credentials.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
import 'package:paperless_mobile/features/logging/utils/redaction_utils.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/model/login_form_credentials.dart';
import 'package:paperless_mobile/features/login/model/reachability_status.dart';
import 'package:paperless_mobile/features/login/services/authentication_service.dart';
import 'package:paperless_mobile/features/notifications/services/local_notification_service.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

part 'authentication_state.dart';

typedef _FutureVoidCallback = Future<void> Function();

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final LocalAuthenticationService _localAuthService;
  final PaperlessAuthenticationApi _authenticationApi;
  final PaperlessUserApi _usersApi;
  final LocalStore _store;
  final EncryptedLocalStore _encryptedLocalStore;
  final SessionManager _sessionManager;
  final ConnectivityStatusService _connectivityService;
  final LocalNotificationService _notificationService;

  AuthenticationCubit(
    this._authenticationApi,
    this._usersApi,
    this._sessionManager,
    this._connectivityService,
    this._localAuthService,
    this._notificationService,
    this._store,
    this._encryptedLocalStore,
  ) : super(const UnauthenticatedState());

  Future<void> login({
    required LoginFormCredentials credentials,
    required String serverUrl,
    ClientCertificate? clientCertificate,
  }) async {
    assert(credentials.username != null && credentials.password != null);
    if (state is AuthenticatingState) {
      // Cancel duplicate login requests
      return;
    }
    emit(const AuthenticatingState(AuthenticatingStage.authenticating));
    final localUserId = "${credentials.username}@$serverUrl";
    final redactedId = redactUserId(localUserId);

    logger.fd(
      "Trying to log in $redactedId...",
      className: runtimeType.toString(),
      methodName: 'login',
    );
    try {
      await _addUser(
        localUserId,
        serverUrl,
        credentials,
        clientCertificate,
        _sessionManager,
        onFetchUserInformation: () async {
          emit(
            const AuthenticatingState(
              AuthenticatingStage.fetchingUserInformation,
            ),
          );
        },
        onBeforeLogin: () async {
          emit(const AuthenticatingState(AuthenticatingStage.authenticating));
        },
        onBeforePersistLocalUserData: () async {
          emit(
            const AuthenticatingState(
              AuthenticatingStage.persistingLocalUserData,
            ),
          );
        },
      );
    } on PaperlessApiException catch (_) {
      emit(
        AuthenticationErrorState(
          serverUrl: serverUrl,
          username: credentials.username!,
          password: credentials.password!,
          clientCertificate: clientCertificate,
        ),
      );
      rethrow;
    }
    // Mark logged in user as currently active user.
    _store.setLoggedInUserId(localUserId);

    emit(AuthenticatedState(localUserId: localUserId));
    logger.fd(
      'User $redactedId successfully logged in.',
      className: runtimeType.toString(),
      methodName: 'login',
    );
  }

  /// Switches to another account if it exists.
  Future<void> switchAccount(String localUserId) async {
    emit(const SwitchingAccountsState());
    await FileService.instance.initialize();

    final redactedId = redactUserId(localUserId);
    logger.fd(
      'Trying to switch to user $redactedId...',
      className: runtimeType.toString(),
      methodName: 'switchAccount',
    );

    if (!_store.state.localUserData.containsKey(localUserId)) {
      logger.fw(
        'User $redactedId not yet registered. '
        'This should never be the case! But here we are...',
        className: runtimeType.toString(),
        methodName: 'switchAccount',
      );
      return;
    }
    final localUserData = _store.state.localUserData[localUserId]!;

    if (localUserData.isBiometricAuthenticationEnabled) {
      final authenticated = await _localAuthService.authenticateLocalUser(
        "Authenticate to switch your account.",
      );
      if (!authenticated) {
        logger.fw(
          "User could not be authenticated.",
          className: runtimeType.toString(),
          methodName: 'switchAccount',
        );
        emit(VerifyIdentityState(userId: localUserId));
        return;
      }
    }
    final currentlyLoggedInUser = _store.state.loggedInUserId;
    if (currentlyLoggedInUser != localUserId) {
      await _notificationService.cancelUserNotifications(localUserId);
    }

    final credentialsExist = await _encryptedLocalStore.contains(localUserId);
    if (!credentialsExist) {
      logger.fw(
        "Invalid authentication for $redactedId - credentials not found.",
        className: runtimeType.toString(),
        methodName: 'switchAccount',
      );
      return;
    }

    final decryptedState = (await _encryptedLocalStore.read(localUserId))!;

    await _resetExternalState();
    _sessionManager.updateSettings(
      authToken: decryptedState.credentials.token,
      clientCertificate: decryptedState.credentials.clientCertificate,
      baseUrl: localUserData.remoteUser.serverUrl,
    );

    _store.setLoggedInUserId(localUserId);

    final apiVersion = await _getApiVersion(_sessionManager.client);

    await _updateRemoteUser(
      localUserId,
      _sessionManager,
      localUserData.remoteUser,
      apiVersion,
    );

    emit(AuthenticatedState(localUserId: localUserId));
  }

  Future<String> addAccount({
    required LoginFormCredentials credentials,
    required String serverUrl,
    ClientCertificate? clientCertificate,
    required bool enableBiometricAuthentication,
    required String locale,
  }) async {
    assert(credentials.password != null && credentials.username != null);
    final localUserId = "${credentials.username}@$serverUrl";
    final redactedId = redactUserId(localUserId);
    logger.fd(
      "Adding account $redactedId...",
      className: runtimeType.toString(),
      methodName: 'switchAccount',
    );

    final SessionManager sessionManager = SessionManagerImpl([
      LanguageHeaderInterceptor(() => locale),
    ]);
    await _addUser(
      localUserId,
      serverUrl,
      credentials,
      clientCertificate,
      sessionManager,
    );

    return localUserId;
  }

  Future<void> removeAccount(String userId) async {
    final redactedId = redactUserId(userId);
    logger.fd(
      "Trying to remove account $redactedId...",
      className: runtimeType.toString(),
      methodName: 'removeAccount',
    );
    _store.removeUserData(userId);
    await _encryptedLocalStore.clear(userId);
    await FileService.instance.clearUserData(userId: userId);
  }

  ///
  /// Restores the previous session if exists.
  ///
  Future<void> restoreSession([String? userId]) async {
    emit(const RestoringSessionState());
    logger.fd(
      "Trying to restore previous session...",
      className: runtimeType.toString(),
      methodName: 'restoreSession',
    );
    final globalSettings = _store.state.globalSettings;
    final restoreSessionUserId = userId ?? _store.state.loggedInUserId;
    // final localUserId = globalSettings.loggedInUserId;
    if (restoreSessionUserId == null ||
        !_store.state.localUserData.containsKey(restoreSessionUserId)) {
      logger.fd(
        "There is nothing to restore.",
        className: runtimeType.toString(),
        methodName: 'restoreSession',
      );
      final otherAccountsExist = _store.state.localUserData.isNotEmpty;
      // If there is nothing to restore, we can quit here.
      emit(
        UnauthenticatedState(redirectToAccountSelection: otherAccountsExist),
      );
      return;
    }
    final localUserData = _store.state.localUserData[restoreSessionUserId]!;
    if (localUserData.isBiometricAuthenticationEnabled) {
      logger.fd(
        "Verifying user identity...",
        className: runtimeType.toString(),
        methodName: 'restoreSession',
      );
      final authenticationMesage = (await S.delegate.load(
        Locale(globalSettings.preferredLocaleSubtag),
      )).verifyYourIdentity;
      final localAuthSuccess = await _localAuthService.authenticateLocalUser(
        authenticationMesage,
      );
      if (!localAuthSuccess) {
        logger.fw(
          "Identity could not be verified.",
          className: runtimeType.toString(),
          methodName: 'restoreSession',
        );
        emit(VerifyIdentityState(userId: restoreSessionUserId));
        return;
      }
      logger.fd(
        "Identity successfully verified.",
        className: runtimeType.toString(),
        methodName: 'restoreSession',
      );
    }
    logger.fd(
      "Reading encrypted credentials...",
      className: runtimeType.toString(),
      methodName: 'restoreSession',
    );
    final decryptedState = await _encryptedLocalStore.read(
      restoreSessionUserId,
    );

    if (decryptedState == null) {
      logger.fe(
        "Credentials could not be read!",
        className: runtimeType.toString(),
        methodName: 'restoreSession',
      );
      throw Exception(
        "User should be authenticated but no authentication information was found.",
      );
    }
    logger.fd(
      "Credentials successfully retrieved.",
      className: runtimeType.toString(),
      methodName: 'restoreSession',
    );

    logger.fd(
      "Updating security context...",
      className: runtimeType.toString(),
      methodName: 'restoreSession',
    );

    _sessionManager.updateSettings(
      clientCertificate: decryptedState.credentials.clientCertificate,
      authToken: decryptedState.credentials.token,
      baseUrl: localUserData.remoteUser.serverUrl,
    );
    logger.fd(
      "Security context successfully updated.",
      className: runtimeType.toString(),
      methodName: 'restoreSession',
    );
    final isPaperlessServerReachable =
        await _connectivityService.isPaperlessServerReachable(
          localUserData.remoteUser.serverUrl,
          decryptedState.credentials.clientCertificate,
        ) ==
        ReachabilityStatus.reachable;
    logger.fd(
      "Trying to update remote paperless user...",
      className: runtimeType.toString(),
      methodName: 'restoreSession',
    );
    if (isPaperlessServerReachable) {
      final apiVersion = await _getApiVersion(_sessionManager.client);
      await _updateRemoteUser(
        restoreSessionUserId,
        _sessionManager,
        localUserData.remoteUser,
        apiVersion,
      );
      logger.fd(
        "Successfully updated remote paperless user.",
        className: runtimeType.toString(),
        methodName: 'restoreSession',
      );
    } else {
      logger.fw(
        "Could not update remote paperless user - "
        "Server could not be reached. The app might behave unexpected!",
        className: runtimeType.toString(),
        methodName: 'restoreSession',
      );
    }
    _store.setLoggedInUserId(restoreSessionUserId);
    emit(AuthenticatedState(localUserId: restoreSessionUserId));

    logger.fd(
      "Previous session successfully restored.",
      className: runtimeType.toString(),
      methodName: 'restoreSession',
    );
  }

  Future<void> logout([bool shouldRemoveAccount = false]) async {
    emit(const LoggingOutState());
    final userId = _store.state.loggedInUserId!;
    final redactedId = redactUserId(userId);

    logger.fd(
      "Logging out $redactedId...",
      className: runtimeType.toString(),
      methodName: 'logout',
    );
    await _resetExternalState();
    CachedQuery.instance.deleteCache();

    await _notificationService.cancelUserNotifications(userId);

    final otherAccountsExist = _store.state.localUserData.keys.length > 1;

    emit(UnauthenticatedState(redirectToAccountSelection: otherAccountsExist));

    if (shouldRemoveAccount) {
      await removeAccount(userId);
    }

    _store.setLoggedInUserId(null);

    logger.fd(
      "User successfully logged out.",
      className: runtimeType.toString(),
      methodName: 'logout',
    );
  }

  Future<void> _resetExternalState() async {
    logger.fd(
      "Resetting security context...",
      className: runtimeType.toString(),
      methodName: '_resetExternalState',
    );
    _sessionManager.resetSettings();
    logger.fd(
      "Security context reset.",
      className: runtimeType.toString(),
      methodName: '_resetExternalState',
    );
    logger.fd(
      "Clearing local state...",
      className: runtimeType.toString(),
      methodName: '_resetExternalState',
    );
    await HydratedBloc.storage.clear();
    logger.fd(
      "Local state cleard.",
      className: runtimeType.toString(),
      methodName: '_resetExternalState',
    );
  }

  Future<int> _addUser(
    String localUserId,
    String serverUrl,
    LoginFormCredentials credentials,
    ClientCertificate? clientCert,
    SessionManager sessionManager, {
    _FutureVoidCallback? onBeforeLogin,
    _FutureVoidCallback? onBeforePersistLocalUserData,
    _FutureVoidCallback? onFetchUserInformation,
  }) async {
    assert(credentials.username != null && credentials.password != null);
    final redactedId = redactUserId(localUserId);

    logger.fd(
      "Adding new user $redactedId..",
      className: runtimeType.toString(),
      methodName: '_addUser',
    );

    sessionManager.updateSettings(
      baseUrl: serverUrl,
      clientCertificate: clientCert,
    );

    await onBeforeLogin?.call();

    logger.fd(
      "Fetching bearer token from the server...",
      className: runtimeType.toString(),
      methodName: '_addUser',
    );

    final token = await _authenticationApi.token(
      PaperlessAuthTokenRequest(
        username: credentials.username!,
        password: credentials.password!,
      ),
    );

    logger.fd(
      "Bearer token successfully retrieved.",
      className: runtimeType.toString(),
      methodName: '_addUser',
    );

    sessionManager.updateSettings(
      baseUrl: serverUrl,
      clientCertificate: clientCert,
      authToken: token,
    );

    if (_store.state.localUserData.containsKey(localUserId)) {
      logger.fw(
        "The user $redactedId already exists.",
        className: runtimeType.toString(),
        methodName: '_addUser',
      );
      throw InfoMessageException(code: ErrorCode.userAlreadyExists);
    }
    await onFetchUserInformation?.call();

    final apiVersion = await _getApiVersion(sessionManager.client);
    logger.fd(
      "Trying to fetch remote paperless user for $redactedId.",
      className: runtimeType.toString(),
      methodName: '_addUser',
    );

    late User? serverUser;

    try {
      serverUser = await _usersApi.getCurrentUser();
    } on DioException catch (error, stackTrace) {
      logger.fe(
        "An error occurred while fetching the remote paperless user.",
        className: runtimeType.toString(),
        methodName: '_addUser',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
    if (serverUser == null) {
      logger.fe(
        "Could not fetch remote paperless user!",
        className: runtimeType.toString(),
        methodName: '_addUser',
      );
      throw InfoMessageException(code: ErrorCode.userGetError);
    }
    logger.fd(
      "Remote paperless user successfully fetched.",
      className: runtimeType.toString(),
      methodName: '_addUser',
    );

    logger.fd(
      "Persisting user data...",
      className: runtimeType.toString(),
      methodName: '_addUser',
    );

    await onBeforePersistLocalUserData?.call();

    _store.updateUserData(
      localUserId,
      (_) => LocalUserData(
        userId: localUserId,
        remoteUser: LocalUserAccount(
          serverUrl: serverUrl,
          paperlessUser: serverUser!,
          apiVersion: apiVersion,
        ),
      ),
    );

    logger.fd(
      "User data successfully persisted.",
      className: runtimeType.toString(),
      methodName: '_addUser',
    );

    logger.fd(
      "Saving user credentials inside encrypted storage...",
      className: runtimeType.toString(),
      methodName: '_addUser',
    );

    _encryptedLocalStore.write(
      localUserId,
      EncryptedLocalStoreState(
        credentials: UserCredentials(
          token: token,
          clientCertificate: clientCert,
        ),
      ),
    );
    logger.fd(
      "User credentials successfully saved.",
      className: runtimeType.toString(),
      methodName: '_addUser',
    );

    _store.updateGlobalSettings(
      _store.state.globalSettings.copyWith(
        knownHosts: {
          ..._store.state.globalSettings.knownHosts,
          serverUrl,
        }.toList(),
      ),
    );

    return serverUser.id;
  }

  Future<int> _getApiVersion(
    Dio dio, {
    Duration? timeout,
    int defaultValue = 2,
  }) async {
    logger.fd(
      "Trying to fetch API version...",
      className: runtimeType.toString(),
      methodName: '_getApiVersion',
    );
    try {
      final response = await dio.get(
        "/api/",
        options: Options(sendTimeout: timeout),
      );
      int apiVersion = int.parse(
        response.headers.value('x-api-version') ?? "3",
      );
      if (apiVersion > latestSupportedApiVersion) {
        logger.fw(
          "The server is running a newer API version ($apiVersion) than the app supports (v$latestSupportedApiVersion), falling back to latest supported version (v$latestSupportedApiVersion). "
          "Warning: This might lead to unexpected behavior!",
          className: runtimeType.toString(),
          methodName: '_getApiVersion',
        );
        apiVersion = latestSupportedApiVersion;
      }
      logger.fd(
        "Successfully retrieved API version ($apiVersion).",
        className: runtimeType.toString(),
        methodName: '_getApiVersion',
      );

      return apiVersion;
    } on DioException catch (_) {
      logger.fw(
        "Could not retrieve API version, using default ($defaultValue).",
        className: runtimeType.toString(),
        methodName: '_getApiVersion',
      );
      return defaultValue;
    }
  }

  /// Fetches possibly updated (permissions, name, updated server version and thus new user model, ...) remote user data.
  Future<void> _updateRemoteUser(
    String userId,
    SessionManager sessionManager,
    LocalUserAccount localUserAccount,
    int apiVersion,
  ) async {
    logger.fd(
      "Trying to update remote user object...",
      className: runtimeType.toString(),
      methodName: '_updateRemoteUser',
    );
    final updatedPaperlessUser = await _usersApi.getCurrentUser();
    if (updatedPaperlessUser == null) {
      logger.fe(
        'Could not fetch updated user information!',
        className: runtimeType.toString(),
        methodName: '_updateRemoteUser',
      );
      return;
    }
    _store.updateUserData(
      userId,
      (_) => _store.state.localUserData[userId]!.copyWith(
        remoteUser: localUserAccount.copyWith(
          paperlessUser: updatedPaperlessUser,
          apiVersion: apiVersion,
        ),
      ),
    );
    logger.fd(
      "Successfully updated remote user object.",
      className: runtimeType.toString(),
      methodName: '_updateRemoteUser',
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:paperless_api/generated/lib/src/model/paperless_auth_token_request.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/security/session_manager_impl.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';

part 'authenticate_user_state.dart';

class AuthenticateUserCubit extends Cubit<AuthenticateUserState> {
  AuthenticateUserCubit() : super(const AuthenticateUserInitial());

  Future<void> login({
    required String serverUrl,
    required String username,
    required String password,
    String? otp,
    ClientCertificate? clientCertificate,
  }) async {
    emit(const AuthenticateUserChecking());
    try {
      final sessionManager = SessionManagerImpl()
        ..updateSettings(
          clientCertificate: clientCertificate,
          baseUrl: serverUrl,
        );
      final token = await PaperlessAuthenticationApiImpl(sessionManager.client)
          .token(
            PaperlessAuthTokenRequest(
              username: username,
              password: password,
              code: otp,
            ),
          );
      emit(
        AuthenticateUserSuccess(
          serverUrl: serverUrl,
          token: token,
          username: username,
          clientCertificate: clientCertificate,
        ),
      );
    } on PaperlessApiException catch (error) {
      if (error.code == ErrorCode.mfaCodeRequired) {
        emit(
          AuthenticateUserOtpRequired(
            serverUrl: serverUrl,
            username: username,
            password: password,
            clientCertificate: clientCertificate,
          ),
        );
      } else {
        emit(AuthenticateUserError(genericError: error));
      }
    } on PaperlessFormValidationException catch (error) {
      if (error.hasUnspecificErrorMessage()) {
        emit(
          AuthenticateUserError(nonFieldError: error.unspecificErrorMessage()),
        );
      } else {
        emit(AuthenticateUserError(fieldErrors: error.validationMessages));
      }
    } catch (error) {
      emit(AuthenticateUserError(genericError: error));
    }
  }
}

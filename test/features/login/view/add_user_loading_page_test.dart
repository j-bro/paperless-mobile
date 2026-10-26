import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:paperless_mobile/api/modules/paperless_user_api.dart';
import 'package:paperless_mobile/core/security/session_manager.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/core/store/encrypted_local_store.dart';
import 'package:paperless_mobile/core/store/local_store.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:paperless_mobile/features/login/services/authentication_service.dart';
import 'package:paperless_mobile/features/login/view/add_user_loading_page.dart';
import 'package:paperless_mobile/features/notifications/services/local_notification_service.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class _MockUserApi extends Mock implements PaperlessUserApi {}

class _MockSessionManager extends Mock implements SessionManager {}

class _MockConnectivity extends Mock implements ConnectivityStatusService {}

class _MockLocalAuth extends Mock implements LocalAuthenticationService {}

class _MockNotifications extends Mock implements LocalNotificationService {}

class _MockStore extends Mock implements LocalStore {}

class _MockEncryptedStore extends Mock implements EncryptedLocalStore {}

// Hand-rolled fake: subclasses the real cubit with mock deps (never used)
// and overrides addUser to record the call without touching APIs.
class FakeAuthCubit extends AuthenticationCubit {
  bool addUserCalled = false;

  FakeAuthCubit()
      : super(
          _MockUserApi(),
          _MockSessionManager(),
          _MockConnectivity(),
          _MockLocalAuth(),
          _MockNotifications(),
          _MockStore(),
          _MockEncryptedStore(),
        );

  @override
  Future<void> addUser({
    required String serverUrl,
    required String token,
    dynamic clientCertificate,
    dynamic additionalHeaders,
  }) async {
    addUserCalled = true;
  }
}

Widget _harness(FakeAuthCubit cubit) => MaterialApp(
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      home: BlocProvider<AuthenticationCubit>.value(
        value: cubit,
        child: const AddUserLoadingPage(
          serverUrl: 'https://x.example.com',
          token: 't',
        ),
      ),
    );

void main() {
  testWidgets('renders spinner and triggers addUser', (t) async {
    final cubit = FakeAuthCubit();
    addTearDown(cubit.close);
    await t.pumpWidget(_harness(cubit));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(cubit.addUserCalled, isTrue);
  });

  testWidgets('has explicit error listener (no endless spinner)', (t) async {
    final cubit = FakeAuthCubit();
    addTearDown(cubit.close);
    await t.pumpWidget(_harness(cubit));
    // The page must listen for AuthenticationError explicitly instead of
    // relying on the global pop() handler.
    expect(
      find.byWidgetPredicate(
        (w) => w is BlocListener<AuthenticationCubit, AuthenticationState>,
      ),
      findsOneWidget,
    );
  });
}

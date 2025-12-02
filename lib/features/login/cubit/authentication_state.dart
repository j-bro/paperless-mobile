part of 'authentication_cubit.dart';

sealed class AuthenticationState {
  const AuthenticationState();

  bool get isAuthenticated => this is Authenticated;
}

class Unauthenticated extends AuthenticationState with EquatableMixin {
  final bool redirectToAccountSelection;

  const Unauthenticated({this.redirectToAccountSelection = false});

  @override
  List<Object?> get props => [redirectToAccountSelection];
}

class RestoringSession extends AuthenticationState {
  const RestoringSession();
}

class VerifyingIdentity extends AuthenticationState {
  final String userId;
  const VerifyingIdentity({required this.userId});
}

class Authenticating extends AuthenticationState {
  const Authenticating();
}

class LoggingOutState extends AuthenticationState {
  const LoggingOutState();
}

class Authenticated extends AuthenticationState with EquatableMixin {
  final String localUserId;

  const Authenticated({required this.localUserId});

  @override
  List<Object?> get props => [localUserId];
}

class SwitchingAccounts extends AuthenticationState {
  const SwitchingAccounts();
}

class AuthenticationError extends AuthenticationState with EquatableMixin {
  final ErrorCode? errorCode;
  final String serverUrl;
  final ClientCertificate? clientCertificate;
  final String username;

  const AuthenticationError({
    this.errorCode,
    required this.serverUrl,
    this.clientCertificate,
    required this.username,
  });

  @override
  List<Object?> get props => [
    errorCode,
    serverUrl,
    clientCertificate,
    username,
  ];
}

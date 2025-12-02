part of 'authenticate_user_cubit.dart';

sealed class AuthenticateUserState {
  const AuthenticateUserState();
}

class AuthenticateUserInitial extends AuthenticateUserState {
  const AuthenticateUserInitial();
}

class AuthenticateUserChecking extends AuthenticateUserState {
  const AuthenticateUserChecking();
}

class AuthenticateUserOtpRequired extends AuthenticateUserState {
  final String serverUrl;
  final String username;
  final String password;
  final ClientCertificate? clientCertificate;
  const AuthenticateUserOtpRequired({
    required this.serverUrl,
    required this.username,
    required this.password,
    this.clientCertificate,
  });
}

class AuthenticateUserFieldValidationError extends AuthenticateUserState {
  final Map<String, String> fieldErrors;
  const AuthenticateUserFieldValidationError({required this.fieldErrors});
}

class AuthenticateUserSuccess extends AuthenticateUserState {
  final String token;
  final String serverUrl;
  final String username;
  final ClientCertificate? clientCertificate;
  const AuthenticateUserSuccess({
    required this.token,
    required this.serverUrl,
    required this.username,
    this.clientCertificate,
  });
}

class AuthenticateUserError extends AuthenticateUserState {
  final Map<String, String>? fieldErrors;
  final String? nonFieldError;
  final dynamic genericError;
  const AuthenticateUserError({
    this.fieldErrors,
    this.nonFieldError,
    this.genericError,
  });
}

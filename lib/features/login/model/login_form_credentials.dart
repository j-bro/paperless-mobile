class LoginFormCredentials {
  final String? username;
  final String? password;
  final String? otp;

  LoginFormCredentials({this.username, this.password, this.otp});

  LoginFormCredentials copyWith({
    String? username,
    String? password,
    String? otp,
  }) {
    return LoginFormCredentials(
      username: username ?? this.username,
      password: password ?? this.password,
      otp: otp ?? this.otp,
    );
  }
}

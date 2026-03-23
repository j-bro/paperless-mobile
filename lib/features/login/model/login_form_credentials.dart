import 'package:copy_with_extension/copy_with_extension.dart';

part 'login_form_credentials.g.dart';

@CopyWith()
class LoginFormCredentials {
  final String? username;
  final String? password;
  final String? apiKey;

  LoginFormCredentials({this.username, this.password, this.apiKey});
}

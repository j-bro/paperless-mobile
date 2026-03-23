import 'package:freezed_annotation/freezed_annotation.dart';

part 'mail_account_test_response.freezed.dart';
part 'mail_account_test_response.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class MailAccountTestResponse with _$MailAccountTestResponse {
  factory MailAccountTestResponse({required bool success}) =
      _MailAccountTestResponse;

  factory MailAccountTestResponse.fromJson(Map<String, dynamic> json) =>
      _$MailAccountTestResponseFromJson(json);
}

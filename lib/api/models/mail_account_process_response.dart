import 'package:freezed_annotation/freezed_annotation.dart';

part 'mail_account_process_response.freezed.dart';
part 'mail_account_process_response.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class MailAccountProcessResponse with _$MailAccountProcessResponse {
  factory MailAccountProcessResponse({@Default('OK') String result}) =
      _MailAccountProcessResponse;

  factory MailAccountProcessResponse.fromJson(Map<String, dynamic> json) =>
      _$MailAccountProcessResponseFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_request_request.freezed.dart';
part 'email_request_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class EmailRequestRequest with _$EmailRequestRequest {
  factory EmailRequestRequest({
    required String addresses,
    required String subject,
    required String message,
    @Default(true) bool? useArchiveVersion,
  }) = _EmailRequestRequest;
}

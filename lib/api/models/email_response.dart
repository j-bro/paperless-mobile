import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_response.freezed.dart';
part 'email_response.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class EmailResponse with _$EmailResponse {
  factory EmailResponse({required String message}) = _EmailResponse;

  factory EmailResponse.fromJson(Map<String, dynamic> json) =>
      _$EmailResponseFromJson(json);
}

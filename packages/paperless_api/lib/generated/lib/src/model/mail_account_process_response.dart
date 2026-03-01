//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'mail_account_process_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MailAccountProcessResponse {
  /// Returns a new [MailAccountProcessResponse] instance.
  MailAccountProcessResponse({this.result = 'OK'});

  @JsonKey(
    defaultValue: 'OK',
    name: r'result',
    required: false,
    includeIfNull: false,
  )
  final String? result;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MailAccountProcessResponse &&
            runtimeType == other.runtimeType &&
            equals([result], [other.result]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([result]);

  factory MailAccountProcessResponse.fromJson(Map<String, dynamic> json) =>
      _$MailAccountProcessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MailAccountProcessResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

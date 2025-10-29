//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'mail_account_test_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MailAccountTestResponse {
  /// Returns a new [MailAccountTestResponse] instance.
  MailAccountTestResponse({required this.success});

  @JsonKey(name: r'success', required: true, includeIfNull: false)
  final bool success;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MailAccountTestResponse &&
            runtimeType == other.runtimeType &&
            equals([success], [other.success]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([success]);

  factory MailAccountTestResponse.fromJson(Map<String, dynamic> json) =>
      _$MailAccountTestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MailAccountTestResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

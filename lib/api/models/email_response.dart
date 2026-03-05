//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'email_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EmailResponse {
  /// Returns a new [EmailResponse] instance.
  EmailResponse({required this.message});

  @JsonKey(name: r'message', required: true, includeIfNull: false)
  final String message;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EmailResponse &&
            runtimeType == other.runtimeType &&
            equals([message], [other.message]);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode([message]);

  factory EmailResponse.fromJson(Map<String, dynamic> json) =>
      _$EmailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EmailResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'email_request_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EmailRequestRequest {
  /// Returns a new [EmailRequestRequest] instance.
  EmailRequestRequest({
    required this.addresses,

    required this.subject,

    required this.message,

    this.useArchiveVersion = true,
  });

  @JsonKey(name: r'addresses', required: true, includeIfNull: false)
  final String addresses;

  @JsonKey(name: r'subject', required: true, includeIfNull: false)
  final String subject;

  @JsonKey(name: r'message', required: true, includeIfNull: false)
  final String message;

  @JsonKey(
    defaultValue: true,
    name: r'use_archive_version',
    required: false,
    includeIfNull: false,
  )
  final bool? useArchiveVersion;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EmailRequestRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [addresses, subject, message, useArchiveVersion],
              [
                other.addresses,
                other.subject,
                other.message,
                other.useArchiveVersion,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([addresses, subject, message, useArchiveVersion]);

  factory EmailRequestRequest.fromJson(Map<String, dynamic> json) =>
      _$EmailRequestRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EmailRequestRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

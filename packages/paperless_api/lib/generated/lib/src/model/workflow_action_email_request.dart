//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'workflow_action_email_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WorkflowActionEmailRequest {
  /// Returns a new [WorkflowActionEmailRequest] instance.
  WorkflowActionEmailRequest({
    this.id,

    required this.subject,

    required this.body,

    required this.to,

    this.includeDocument,
  });

  @JsonKey(name: r'id', required: false, includeIfNull: false)
  final int? id;

  /// The subject of the email, can include some placeholders, see documentation.
  @JsonKey(name: r'subject', required: true, includeIfNull: false)
  final String subject;

  /// The body (message) of the email, can include some placeholders, see documentation.
  @JsonKey(name: r'body', required: true, includeIfNull: false)
  final String body;

  /// The destination email addresses, comma separated.
  @JsonKey(name: r'to', required: true, includeIfNull: false)
  final String to;

  @JsonKey(name: r'include_document', required: false, includeIfNull: false)
  final bool? includeDocument;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WorkflowActionEmailRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [id, subject, body, to, includeDocument],
              [
                other.id,
                other.subject,
                other.body,
                other.to,
                other.includeDocument,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([id, subject, body, to, includeDocument]);

  factory WorkflowActionEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$WorkflowActionEmailRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WorkflowActionEmailRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

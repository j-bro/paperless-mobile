import 'package:freezed_annotation/freezed_annotation.dart';

part 'workflow_action_email.freezed.dart';
part 'workflow_action_email.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class WorkflowActionEmail with _$WorkflowActionEmail {
  factory WorkflowActionEmail({
    int? id,

    /// The subject of the email, can include some placeholders, see documentation.
    required String subject,

    /// The body (message) of the email, can include some placeholders, see documentation.
    required String body,

    /// The destination email addresses, comma separated.
    required String to,
    bool? includeDocument,
  }) = _WorkflowActionEmail;

  factory WorkflowActionEmail.fromJson(Map<String, dynamic> json) =>
      _$WorkflowActionEmailFromJson(json);
}

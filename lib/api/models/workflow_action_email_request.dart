import 'package:freezed_annotation/freezed_annotation.dart';

part 'workflow_action_email_request.freezed.dart';
part 'workflow_action_email_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class WorkflowActionEmailRequest with _$WorkflowActionEmailRequest {
  factory WorkflowActionEmailRequest({
    int? id,

    /// The subject of the email, can include some placeholders, see documentation.
    required String subject,

    /// The body (message) of the email, can include some placeholders, see documentation.
    required String body,

    /// The destination email addresses, comma separated.
    required String to,
    bool? includeDocument,
  }) = _WorkflowActionEmailRequest;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'workflow_action_webhook_request.freezed.dart';
part 'workflow_action_webhook_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class WorkflowActionWebhookRequest
    with _$WorkflowActionWebhookRequest {
  factory WorkflowActionWebhookRequest({
    int? id,

    /// The destination URL for the notification.
    required String url,
    bool? useParams,
    bool? asJson,

    /// The parameters to send with the webhook URL if body not used.
    Object? params,

    /// The body to send with the webhook URL if parameters not used.
    String? body,

    /// The headers to send with the webhook URL.
    Object? headers,
    bool? includeDocument,
  }) = _WorkflowActionWebhookRequest;
}

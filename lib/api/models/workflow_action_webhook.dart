import 'package:freezed_annotation/freezed_annotation.dart';

part 'workflow_action_webhook.freezed.dart';
part 'workflow_action_webhook.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class WorkflowActionWebhook with _$WorkflowActionWebhook {
  factory WorkflowActionWebhook({
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
  }) = _WorkflowActionWebhook;

  factory WorkflowActionWebhook.fromJson(Map<String, dynamic> json) =>
      _$WorkflowActionWebhookFromJson(json);
}

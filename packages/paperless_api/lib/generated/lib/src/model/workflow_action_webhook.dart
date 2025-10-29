//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'workflow_action_webhook.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WorkflowActionWebhook {
  /// Returns a new [WorkflowActionWebhook] instance.
  WorkflowActionWebhook({
    this.id,

    required this.url,

    this.useParams,

    this.asJson,

    this.params,

    this.body,

    this.headers,

    this.includeDocument,
  });

  @JsonKey(name: r'id', required: false, includeIfNull: false)
  final int? id;

  /// The destination URL for the notification.
  @JsonKey(name: r'url', required: true, includeIfNull: false)
  final String url;

  @JsonKey(name: r'use_params', required: false, includeIfNull: false)
  final bool? useParams;

  @JsonKey(name: r'as_json', required: false, includeIfNull: false)
  final bool? asJson;

  /// The parameters to send with the webhook URL if body not used.
  @JsonKey(name: r'params', required: false, includeIfNull: false)
  final Object? params;

  /// The body to send with the webhook URL if parameters not used.
  @JsonKey(name: r'body', required: false, includeIfNull: false)
  final String? body;

  /// The headers to send with the webhook URL.
  @JsonKey(name: r'headers', required: false, includeIfNull: false)
  final Object? headers;

  @JsonKey(name: r'include_document', required: false, includeIfNull: false)
  final bool? includeDocument;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WorkflowActionWebhook &&
            runtimeType == other.runtimeType &&
            equals(
              [
                id,
                url,
                useParams,
                asJson,
                params,
                body,
                headers,
                includeDocument,
              ],
              [
                other.id,
                other.url,
                other.useParams,
                other.asJson,
                other.params,
                other.body,
                other.headers,
                other.includeDocument,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        id,
        url,
        useParams,
        asJson,
        params,
        body,
        headers,
        includeDocument,
      ]);

  factory WorkflowActionWebhook.fromJson(Map<String, dynamic> json) =>
      _$WorkflowActionWebhookFromJson(json);

  Map<String, dynamic> toJson() => _$WorkflowActionWebhookToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

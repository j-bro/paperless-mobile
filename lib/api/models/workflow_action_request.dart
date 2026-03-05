//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_mobile/api/models/workflow_action_email_request.dart';
import 'package:paperless_mobile/api/models/workflow_action_type_enum.dart';
import 'package:paperless_mobile/api/models/workflow_action_webhook_request.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'workflow_action_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WorkflowActionRequest {
  /// Returns a new [WorkflowActionRequest] instance.
  WorkflowActionRequest({
    this.id,

    this.type,

    this.assignTitle,

    this.assignTags,

    this.assignCorrespondent,

    this.assignDocumentType,

    this.assignStoragePath,

    this.assignOwner,

    this.assignViewUsers,

    this.assignViewGroups,

    this.assignChangeUsers,

    this.assignChangeGroups,

    this.assignCustomFields,

    this.assignCustomFieldsValues,

    this.removeAllTags,

    this.removeTags,

    this.removeAllCorrespondents,

    this.removeCorrespondents,

    this.removeAllDocumentTypes,

    this.removeDocumentTypes,

    this.removeAllStoragePaths,

    this.removeStoragePaths,

    this.removeCustomFields,

    this.removeAllCustomFields,

    this.removeAllOwners,

    this.removeOwners,

    this.removeAllPermissions,

    this.removeViewUsers,

    this.removeViewGroups,

    this.removeChangeUsers,

    this.removeChangeGroups,

    this.email,

    this.webhook,
  });

  @JsonKey(name: r'id', required: false, includeIfNull: false)
  final int? id;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'type', required: false, includeIfNull: false)
  final WorkflowActionTypeEnum? type;

  /// Assign a document title, can include some placeholders, see documentation.
  @JsonKey(name: r'assign_title', required: false, includeIfNull: false)
  final String? assignTitle;

  @JsonKey(name: r'assign_tags', required: false, includeIfNull: false)
  final List<int>? assignTags;

  @JsonKey(name: r'assign_correspondent', required: false, includeIfNull: false)
  final int? assignCorrespondent;

  @JsonKey(name: r'assign_document_type', required: false, includeIfNull: false)
  final int? assignDocumentType;

  @JsonKey(name: r'assign_storage_path', required: false, includeIfNull: false)
  final int? assignStoragePath;

  @JsonKey(name: r'assign_owner', required: false, includeIfNull: false)
  final int? assignOwner;

  @JsonKey(name: r'assign_view_users', required: false, includeIfNull: false)
  final List<int>? assignViewUsers;

  @JsonKey(name: r'assign_view_groups', required: false, includeIfNull: false)
  final List<int>? assignViewGroups;

  @JsonKey(name: r'assign_change_users', required: false, includeIfNull: false)
  final List<int>? assignChangeUsers;

  @JsonKey(name: r'assign_change_groups', required: false, includeIfNull: false)
  final List<int>? assignChangeGroups;

  @JsonKey(name: r'assign_custom_fields', required: false, includeIfNull: false)
  final List<int>? assignCustomFields;

  /// Optional values to assign to the custom fields.
  @JsonKey(
    name: r'assign_custom_fields_values',
    required: false,
    includeIfNull: false,
  )
  final Object? assignCustomFieldsValues;

  @JsonKey(name: r'remove_all_tags', required: false, includeIfNull: false)
  final bool? removeAllTags;

  @JsonKey(name: r'remove_tags', required: false, includeIfNull: false)
  final List<int>? removeTags;

  @JsonKey(
    name: r'remove_all_correspondents',
    required: false,
    includeIfNull: false,
  )
  final bool? removeAllCorrespondents;

  @JsonKey(
    name: r'remove_correspondents',
    required: false,
    includeIfNull: false,
  )
  final List<int>? removeCorrespondents;

  @JsonKey(
    name: r'remove_all_document_types',
    required: false,
    includeIfNull: false,
  )
  final bool? removeAllDocumentTypes;

  @JsonKey(
    name: r'remove_document_types',
    required: false,
    includeIfNull: false,
  )
  final List<int>? removeDocumentTypes;

  @JsonKey(
    name: r'remove_all_storage_paths',
    required: false,
    includeIfNull: false,
  )
  final bool? removeAllStoragePaths;

  @JsonKey(name: r'remove_storage_paths', required: false, includeIfNull: false)
  final List<int>? removeStoragePaths;

  @JsonKey(name: r'remove_custom_fields', required: false, includeIfNull: false)
  final List<int>? removeCustomFields;

  @JsonKey(
    name: r'remove_all_custom_fields',
    required: false,
    includeIfNull: false,
  )
  final bool? removeAllCustomFields;

  @JsonKey(name: r'remove_all_owners', required: false, includeIfNull: false)
  final bool? removeAllOwners;

  @JsonKey(name: r'remove_owners', required: false, includeIfNull: false)
  final List<int>? removeOwners;

  @JsonKey(
    name: r'remove_all_permissions',
    required: false,
    includeIfNull: false,
  )
  final bool? removeAllPermissions;

  @JsonKey(name: r'remove_view_users', required: false, includeIfNull: false)
  final List<int>? removeViewUsers;

  @JsonKey(name: r'remove_view_groups', required: false, includeIfNull: false)
  final List<int>? removeViewGroups;

  @JsonKey(name: r'remove_change_users', required: false, includeIfNull: false)
  final List<int>? removeChangeUsers;

  @JsonKey(name: r'remove_change_groups', required: false, includeIfNull: false)
  final List<int>? removeChangeGroups;

  @JsonKey(name: r'email', required: false, includeIfNull: false)
  final WorkflowActionEmailRequest? email;

  @JsonKey(name: r'webhook', required: false, includeIfNull: false)
  final WorkflowActionWebhookRequest? webhook;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WorkflowActionRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [
                id,
                type,
                assignTitle,
                assignTags,
                assignCorrespondent,
                assignDocumentType,
                assignStoragePath,
                assignOwner,
                assignViewUsers,
                assignViewGroups,
                assignChangeUsers,
                assignChangeGroups,
                assignCustomFields,
                assignCustomFieldsValues,
                removeAllTags,
                removeTags,
                removeAllCorrespondents,
                removeCorrespondents,
                removeAllDocumentTypes,
                removeDocumentTypes,
                removeAllStoragePaths,
                removeStoragePaths,
                removeCustomFields,
                removeAllCustomFields,
                removeAllOwners,
                removeOwners,
                removeAllPermissions,
                removeViewUsers,
                removeViewGroups,
                removeChangeUsers,
                removeChangeGroups,
                email,
                webhook,
              ],
              [
                other.id,
                other.type,
                other.assignTitle,
                other.assignTags,
                other.assignCorrespondent,
                other.assignDocumentType,
                other.assignStoragePath,
                other.assignOwner,
                other.assignViewUsers,
                other.assignViewGroups,
                other.assignChangeUsers,
                other.assignChangeGroups,
                other.assignCustomFields,
                other.assignCustomFieldsValues,
                other.removeAllTags,
                other.removeTags,
                other.removeAllCorrespondents,
                other.removeCorrespondents,
                other.removeAllDocumentTypes,
                other.removeDocumentTypes,
                other.removeAllStoragePaths,
                other.removeStoragePaths,
                other.removeCustomFields,
                other.removeAllCustomFields,
                other.removeAllOwners,
                other.removeOwners,
                other.removeAllPermissions,
                other.removeViewUsers,
                other.removeViewGroups,
                other.removeChangeUsers,
                other.removeChangeGroups,
                other.email,
                other.webhook,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        id,
        type,
        assignTitle,
        assignTags,
        assignCorrespondent,
        assignDocumentType,
        assignStoragePath,
        assignOwner,
        assignViewUsers,
        assignViewGroups,
        assignChangeUsers,
        assignChangeGroups,
        assignCustomFields,
        assignCustomFieldsValues,
        removeAllTags,
        removeTags,
        removeAllCorrespondents,
        removeCorrespondents,
        removeAllDocumentTypes,
        removeDocumentTypes,
        removeAllStoragePaths,
        removeStoragePaths,
        removeCustomFields,
        removeAllCustomFields,
        removeAllOwners,
        removeOwners,
        removeAllPermissions,
        removeViewUsers,
        removeViewGroups,
        removeChangeUsers,
        removeChangeGroups,
        email,
        webhook,
      ]);

  factory WorkflowActionRequest.fromJson(Map<String, dynamic> json) =>
      _$WorkflowActionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WorkflowActionRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

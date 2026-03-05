//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_mobile/api/models/custom_field_instance_request.dart';
import 'package:paperless_mobile/api/models/correspondent_request_set_permissions.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'document_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DocumentRequest {
  /// Returns a new [DocumentRequest] instance.
  DocumentRequest({
    required this.correspondent,

    required this.documentType,

    required this.storagePath,

    this.title,

    this.content,

    required this.tags,

    this.created,

    this.createdDate,

    this.deletedAt,

    this.archiveSerialNumber,

    this.owner,

    this.setPermissions,

    this.customFields,

    this.removeInboxTags = false,
  });

  @JsonKey(name: r'correspondent', required: true, includeIfNull: true)
  final int? correspondent;

  @JsonKey(name: r'document_type', required: true, includeIfNull: true)
  final int? documentType;

  @JsonKey(name: r'storage_path', required: true, includeIfNull: true)
  final int? storagePath;

  @JsonKey(name: r'title', required: false, includeIfNull: false)
  final String? title;

  /// The raw, text-only data of the document. This field is primarily used for searching.
  @JsonKey(name: r'content', required: false, includeIfNull: false)
  final String? content;

  @JsonKey(name: r'tags', required: true, includeIfNull: false)
  final List<int> tags;

  @JsonKey(name: r'created', required: false, includeIfNull: false)
  final DateTime? created;

  @Deprecated('createdDate has been deprecated')
  @JsonKey(name: r'created_date', required: false, includeIfNull: false)
  final DateTime? createdDate;

  @JsonKey(name: r'deleted_at', required: false, includeIfNull: false)
  final DateTime? deletedAt;

  /// The position of this document in your physical document archive.
  // minimum: 0
  // maximum: 4294967295
  @JsonKey(
    name: r'archive_serial_number',
    required: false,
    includeIfNull: false,
  )
  final int? archiveSerialNumber;

  @JsonKey(name: r'owner', required: false, includeIfNull: false)
  final int? owner;

  @JsonKey(name: r'set_permissions', required: false, includeIfNull: false)
  final CorrespondentRequestSetPermissions? setPermissions;

  @JsonKey(name: r'custom_fields', required: false, includeIfNull: false)
  final List<CustomFieldInstanceRequest>? customFields;

  @JsonKey(
    defaultValue: false,
    name: r'remove_inbox_tags',
    required: false,
    includeIfNull: false,
  )
  final bool? removeInboxTags;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DocumentRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [
                correspondent,
                documentType,
                storagePath,
                title,
                content,
                tags,
                created,
                createdDate,
                deletedAt,
                archiveSerialNumber,
                owner,
                setPermissions,
                customFields,
                removeInboxTags,
              ],
              [
                other.correspondent,
                other.documentType,
                other.storagePath,
                other.title,
                other.content,
                other.tags,
                other.created,
                other.createdDate,
                other.deletedAt,
                other.archiveSerialNumber,
                other.owner,
                other.setPermissions,
                other.customFields,
                other.removeInboxTags,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        correspondent,
        documentType,
        storagePath,
        title,
        content,
        tags,
        created,
        createdDate,
        deletedAt,
        archiveSerialNumber,
        owner,
        setPermissions,
        customFields,
        removeInboxTags,
      ]);

  factory DocumentRequest.fromJson(Map<String, dynamic> json) =>
      _$DocumentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

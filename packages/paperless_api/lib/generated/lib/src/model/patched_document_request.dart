//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/src/equatable_utils.dart';
// ignore_for_file: unused_element
import 'package:fpdart/fpdart.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/generated/lib/src/model/correspondent_request_set_permissions.dart';
import 'package:paperless_api/generated/lib/src/model/custom_field_instance_request.dart';

part 'patched_document_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PatchedDocumentRequest {
  /// Returns a new [PatchedDocumentRequest] instance.
  PatchedDocumentRequest({
    this.correspondent,
    this.documentType,
    this.storagePath,
    this.title,
    this.content,
    this.tags,
    this.created,
    this.createdDate,
    this.deletedAt,
    this.archiveSerialNumber,
    this.owner,
    this.setPermissions,
    this.customFields,
    this.removeInboxTags = false,
  });

  @JsonKey(name: r'correspondent', required: false, includeIfNull: false)
  final Option<int?>? correspondent;

  @JsonKey(name: r'document_type', required: false, includeIfNull: false)
  final Option<int?>? documentType;

  @JsonKey(name: r'storage_path', required: false, includeIfNull: false)
  final Option<int?>? storagePath;

  @JsonKey(name: r'title', required: false, includeIfNull: false)
  final Option<String?>? title;

  /// The raw, text-only data of the document. This field is primarily used for searching.
  @JsonKey(name: r'content', required: false, includeIfNull: false)
  final Option<String?>? content;

  @JsonKey(name: r'tags', required: false, includeIfNull: false)
  final Option<List<int>?>? tags;

  @JsonKey(name: r'created', required: false, includeIfNull: false)
  final Option<DateTime?>? created;

  @Deprecated('createdDate has been deprecated')
  @JsonKey(name: r'created_date', required: false, includeIfNull: false)
  final Option<DateTime?>? createdDate;

  @JsonKey(name: r'deleted_at', required: false, includeIfNull: false)
  final Option<DateTime?>? deletedAt;

  /// The position of this document in your physical document archive.
  // minimum: 0
  // maximum: 4294967295
  @JsonKey(
    name: r'archive_serial_number',
    required: false,
    includeIfNull: false,
  )
  final Option<int?>? archiveSerialNumber;

  @JsonKey(name: r'owner', required: false, includeIfNull: false)
  final Option<int?>? owner;

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
        other is PatchedDocumentRequest &&
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

  factory PatchedDocumentRequest.fromJson(Map<String, dynamic> json) =>
      _$PatchedDocumentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PatchedDocumentRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

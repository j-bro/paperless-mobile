//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/src/equatable_utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_mobile/api/models/correspondent_request_set_permissions.dart';
import 'package:paperless_mobile/api/models/custom_field_instance_request.dart';
import 'package:paperless_mobile/api/converters/optional_json_converter.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_document_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createFactory: false,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: false,
  includeIfNull: true,
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

  @JsonKey(name: r'correspondent')
  final PatchedValue<int?>? correspondent;

  @JsonKey(name: r'document_type')
  final PatchedValue<int?>? documentType;

  @JsonKey(name: r'storage_path')
  final PatchedValue<int?>? storagePath;

  @JsonKey(name: r'title')
  final PatchedValue<String?>? title;

  /// The raw, text-only data of the document. This field is primarily used for searching.
  @JsonKey(name: r'content')
  final PatchedValue<String?>? content;

  @JsonKey(name: r'tags')
  final PatchedValue<List<int>?>? tags;

  @JsonKey(name: r'created')
  final PatchedValue<DateTime?>? created;

  @Deprecated('createdDate has been deprecated')
  @JsonKey(name: r'created_date')
  final PatchedValue<DateTime?>? createdDate;

  @JsonKey(name: r'deleted_at')
  final PatchedValue<DateTime?>? deletedAt;

  /// The position of this document in your physical document archive.
  // minimum: 0
  // maximum: 4294967295
  @JsonKey(name: r'archive_serial_number')
  final PatchedValue<int?>? archiveSerialNumber;

  @JsonKey(name: r'owner')
  final PatchedValue<int?>? owner;

  @JsonKey(name: r'set_permissions')
  final CorrespondentRequestSetPermissions? setPermissions;

  @JsonKey(name: r'custom_fields')
  final PatchedValue<List<CustomFieldInstanceRequest>?>? customFields;

  @JsonKey(name: r'remove_inbox_tags')
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

  @JsonKey(includeToJson: true)
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

  Map<String, dynamic> toJson() =>
      convertPatchedValueJson(_$PatchedDocumentRequestToJson(this));

  @override
  String toString() {
    return toJson().toString();
  }
}

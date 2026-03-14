//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_mobile/api/models/custom_field_instance.dart';
import 'package:paperless_mobile/api/models/document_permissions.dart';
import 'package:paperless_mobile/api/models/note.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'document.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Document {
  /// Returns a new [Document] instance.
  Document({
    required this.id,
    this.correspondent,
    this.documentType,
    this.storagePath,
    this.title,
    this.content,
    this.tags = const [],
    this.created,
    this.createdDate,
    this.modified,
    this.added,
    this.deletedAt,
    this.archiveSerialNumber,
    this.originalFileName,
    this.archivedFileName,
    this.owner,
    this.permissions,
    this.userCanChange,
    this.isSharedByRequester,
    this.notes = const [],
    this.customFields,
    this.pageCount,
    this.mimeType,
  });

  @JsonKey(name: r'id', includeIfNull: false)
  final int id;

  @JsonKey(name: r'correspondent', includeIfNull: true)
  final int? correspondent;

  @JsonKey(name: r'document_type', includeIfNull: true)
  final int? documentType;

  @JsonKey(name: r'storage_path', includeIfNull: true)
  final int? storagePath;

  @JsonKey(name: r'title', required: false, includeIfNull: false)
  final String? title;

  /// The raw, text-only data of the document. This field is primarily used for searching.
  @JsonKey(name: r'content', required: false, includeIfNull: false)
  final String? content;

  @JsonKey(name: r'tags', includeIfNull: false)
  final List<int> tags;

  @JsonKey(name: r'created', required: false, includeIfNull: false)
  final DateTime? created;

  @Deprecated('createdDate has been deprecated')
  @JsonKey(name: r'created_date', required: false, includeIfNull: false)
  final DateTime? createdDate;

  @JsonKey(name: r'modified', includeIfNull: false)
  final DateTime? modified;

  @JsonKey(name: r'added', includeIfNull: false)
  final DateTime? added;

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

  @JsonKey(name: r'original_file_name', includeIfNull: true)
  final String? originalFileName;

  @JsonKey(name: r'archived_file_name', includeIfNull: true)
  final String? archivedFileName;

  @JsonKey(name: r'owner', required: false, includeIfNull: false)
  final int? owner;

  @JsonKey(name: r'permissions', required: false, includeIfNull: false)
  final DocumentPermissions? permissions;

  @JsonKey(name: r'user_can_change', required: false, includeIfNull: false)
  final bool? userCanChange;

  @JsonKey(
    name: r'is_shared_by_requester',
    required: false,
    includeIfNull: false,
  )
  final bool? isSharedByRequester;

  @JsonKey(name: r'notes', includeIfNull: false)
  final List<Note> notes;

  @JsonKey(name: r'custom_fields', required: false, includeIfNull: false)
  final List<CustomFieldInstance>? customFields;

  @JsonKey(name: r'page_count', includeIfNull: true)
  final int? pageCount;

  @JsonKey(name: r'mime_type', includeIfNull: false)
  final String? mimeType;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Document &&
            runtimeType == other.runtimeType &&
            equals(
              [
                id,
                correspondent,
                documentType,
                storagePath,
                title,
                content,
                tags,
                created,
                createdDate,
                modified,
                added,
                deletedAt,
                archiveSerialNumber,
                originalFileName,
                archivedFileName,
                owner,
                permissions,
                userCanChange,
                isSharedByRequester,
                notes,
                customFields,
                pageCount,
                mimeType,
              ],
              [
                other.id,
                other.correspondent,
                other.documentType,
                other.storagePath,
                other.title,
                other.content,
                other.tags,
                other.created,
                other.createdDate,
                other.modified,
                other.added,
                other.deletedAt,
                other.archiveSerialNumber,
                other.originalFileName,
                other.archivedFileName,
                other.owner,
                other.permissions,
                other.userCanChange,
                other.isSharedByRequester,
                other.notes,
                other.customFields,
                other.pageCount,
                other.mimeType,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        id,
        correspondent,
        documentType,
        storagePath,
        title,
        content,
        tags,
        created,
        createdDate,
        modified,
        added,
        deletedAt,
        archiveSerialNumber,
        originalFileName,
        archivedFileName,
        owner,
        permissions,
        userCanChange,
        isSharedByRequester,
        notes,
        customFields,
        pageCount,
        mimeType,
      ]);

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

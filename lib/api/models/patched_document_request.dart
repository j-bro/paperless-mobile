import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/correspondent_request_set_permissions.dart';
import 'package:paperless_mobile/api/models/custom_field_instance_request.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_document_request.g.dart';

@JsonSerializable(
  createFactory: false,
  createToJson: true,
  includeIfNull: false,
)
class PatchedDocumentRequest {
  final PatchedValue<int?>? correspondent;
  final PatchedValue<int?>? documentType;
  final PatchedValue<int?>? storagePath;
  final PatchedValue<String?>? title;

  /// The raw; text-only data of the document. This field is primarily used for searching.
  final PatchedValue<String?>? content;
  final PatchedValue<List<int>?>? tags;
  final PatchedValue<DateTime?>? created;
  final PatchedValue<DateTime?>? deletedAt;

  /// The position of this document in your physical document archive.
  // minimum: 0
  // maximum: 4294967295
  final PatchedValue<int?>? archiveSerialNumber;
  final PatchedValue<int?>? owner;
  final CorrespondentRequestSetPermissions? setPermissions;
  final PatchedValue<List<CustomFieldInstanceRequest>?>? customFields;
  final PatchedValue<bool?>? removeInboxTags;

  PatchedDocumentRequest({
    this.correspondent,
    this.documentType,
    this.storagePath,
    this.title,
    this.content,
    this.tags,
    this.created,
    this.deletedAt,
    this.archiveSerialNumber,
    this.owner,
    this.setPermissions,
    this.customFields,
    this.removeInboxTags,
  });

  Map<String, dynamic> toJson() =>
      processPatchedValueJson(_$PatchedDocumentRequestToJson(this));
}

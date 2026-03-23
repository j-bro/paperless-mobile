import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/api/paperless_api.dart';

extension DocumentModelIterableExtension on Iterable<Document> {
  List<int> get ids => map((e) => e.id).toList();

  bool containsDocument(Document document) {
    return ids.contains(document.id);
  }

  Iterable<Document> withDocumentRemoved(Document document) {
    return whereNot((element) => element.id == document.id);
  }
}

extension SessionAwareDownloadIdExtension on Document {
  String buildThumbnailUrl(BuildContext context) =>
      context.read<PaperlessDocumentsApi>().getThumbnailUrl(id);
}

extension MergeRequestIntoDocumentExtension on Document {
  Document mergePatchedRequest(PatchedDocumentRequest arg) {
    return copyWith(
      title: arg.title != null ? arg.title!.value : title,
      documentType: arg.documentType != null
          ? arg.documentType!.value
          : documentType,
      correspondent: arg.correspondent != null
          ? arg.correspondent!.value
          : correspondent,
      storagePath: arg.storagePath != null
          ? arg.storagePath!.value
          : storagePath,
      customFields: arg.customFields != null
          ? (arg.customFields!.value
                    ?.map(
                      (e) =>
                          CustomFieldInstance(value: e.value, field: e.field),
                    )
                    .toList() ??
                [])
          : customFields,
      tags: arg.tags != null ? (arg.tags!.value ?? []) : tags,
      created: arg.created != null ? arg.created!.value : created,
      content: arg.content != null ? arg.content!.value : content,
      owner: arg.owner != null ? arg.owner!.value : owner,
      archiveSerialNumber: arg.archiveSerialNumber != null
          ? arg.archiveSerialNumber!.value
          : archiveSerialNumber,
      deletedAt: arg.deletedAt != null ? arg.deletedAt!.value : deletedAt,
    );
  }

  Document mergeRequest(DocumentRequest arg) {
    return copyWith(
      title: arg.title,
      documentType: arg.documentType,
      correspondent: arg.correspondent,
      storagePath: arg.storagePath,
      customFields: arg.customFields
          ?.map((e) => CustomFieldInstance(value: e.value, field: e.field))
          .toList(),
      tags: arg.tags,
      created: arg.created,
      content: arg.content,
      owner: arg.owner,
      archiveSerialNumber: arg.archiveSerialNumber,
    );
  }
}

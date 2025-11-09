import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/generated/lib/src/model/document.dart';
import 'package:paperless_api/paperless_api.dart';

extension DocumentModelIterableExtension on Iterable<Document> {
  Iterable<int> get ids => map((e) => e.id);

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

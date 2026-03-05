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

import 'package:paperless_api/generated/lib/src/model/document.dart';
import 'package:paperless_api/generated/lib/src/model/paginated_document_list.dart';

extension PaginationExtensions on List<PaginatedDocumentList> {
  List<Document> get flattened {
    return expand((e) => e.results).toList();
  }

  bool get isLastPageLoaded {
    if (length > 0) {
      return last.next == null;
    }
    return false;
  }
}

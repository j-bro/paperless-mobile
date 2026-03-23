import 'package:paperless_mobile/api/models/models.dart';

extension PaginationExtensions<T> on List<PaginatedResultList<T>> {
  List<T> get flattened {
    return expand((e) => e.results).toList();
  }

  bool get isLastPageLoaded {
    if (length > 0) {
      return last.next == null;
    }
    return false;
  }
}

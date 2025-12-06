import 'package:paperless_api/paperless_api.dart';

extension SavedViewExtension on SavedView {
  DocumentFilter toDocumentFilter() {
    return filterRules.fold(
      DocumentFilter(
        sortOrder: (sortReverse ?? false)
            ? SortOrder.descending
            : SortOrder.ascending,
        sortField: SortField.values.firstWhere((e) => e.name == sortField),
        selectedView: id,
      ),
      (filter, filterRule) => filterRule.applyToFilter(filter),
    );
  }
}

import 'package:collection/collection.dart';
import 'package:paperless_mobile/api/paperless_api.dart';

extension SavedViewExtension on SavedView {
  DocumentFilter toDocumentFilter() {
    return filterRules.fold(
      DocumentFilter(
        sortOrder: (sortReverse ?? false)
            ? SortOrder.descending
            : SortOrder.ascending,
        sortField: SortField.values.firstWhereOrNull(
          (e) => e.value == sortField,
        ),
        selectedView: id,
      ),
      (filter, filterRule) => filterRule.applyToFilter(filter),
    );
  }

  SavedViewRequest toRequest() {
    return SavedViewRequest(
      name: name,
      filterRules: filterRules
          .map(
            (e) => SavedViewFilterRuleRequest(
              ruleType: e.ruleType,
              value: e.value,
            ),
          )
          .toList(),
      sortField: sortField,
      sortReverse: sortReverse,
      showOnDashboard: showOnDashboard,
      showInSidebar: showInSidebar,
    );
  }
}

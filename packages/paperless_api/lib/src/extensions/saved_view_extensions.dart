import 'package:paperless_api/paperless_api.dart';

extension SavedViewExtension on SavedView {
  DocumentFilter toDocumentFilter() {
    return filterRules.fold(
      DocumentFilter(
        sortOrder: (sortReverse ?? false)
            ? SortOrder.descending
            : SortOrder.ascending,
        sortField: SortField.values.firstWhere((e) => e.value == sortField),
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

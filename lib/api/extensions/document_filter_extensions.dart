import 'package:paperless_mobile/api/models/rule_type_enum.dart';
import 'package:paperless_mobile/api/models/saved_view_filter_rule_request.dart';
import 'package:paperless_mobile/api/models/saved_view_request.dart';
import 'package:paperless_mobile/api/extensions/filter_rule_extension.dart';
import 'package:paperless_mobile/api/models/models.dart';

extension SavedViewRequestExtensions on DocumentFilter {
  SavedViewRequest toSavedViewRequest({
    required String name,
    required bool showInSidebar,
    required bool showOnDashboard,
  }) {
    return SavedViewRequest(
      name: name,
      filterRules: toFilterRules()
          .map(
            (e) => SavedViewFilterRuleRequest(
              ruleType: RuleTypeEnum.values.firstWhere(
                (element) => int.tryParse(element.value) == e.ruleType,
              ),
              value: e.value,
            ),
          )
          .toList(),
      sortField: sortField?.value,
      showInSidebar: showInSidebar,
      showOnDashboard: showOnDashboard,
      sortReverse: sortOrder == SortOrder.descending,
    );
  }
}

extension DocumentFilterOptionsConverter on DocumentFilter {
  DocumentFilterOptions toDocumentFilterOptions() {
    return DocumentFilterOptions.fromJson(toQueryParameters());
  }
}

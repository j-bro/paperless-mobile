import 'package:paperless_api/generated/lib/src/model/rule_type_enum.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view_filter_rule_request.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view_request.dart';
import 'package:paperless_api/src/extensions/filter_rule_extension.dart';
import 'package:paperless_api/src/models/models.dart';

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
      sortField: sortField?.queryString,
      showInSidebar: showInSidebar,
      showOnDashboard: showOnDashboard,
      sortReverse: sortOrder == SortOrder.descending,
    );
  }
}

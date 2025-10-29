import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view_filter_rule.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view_filter_rule_request.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view_request.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_api/src/constants/filter_rules.dart';
import 'package:paperless_api/src/extensions/model_extensions.dart';
import 'package:paperless_api/src/extensions/saved_view_extensions.dart';

void main() {
  group('Parsing [SavedView] to [DocumentFilter]:', () {
    test('Values are correctly parsed if set.', () {
      expect(
        SavedView.fromJson({
          "id": 1,
          "name": "test_name",
          "show_on_dashboard": false,
          "show_in_sidebar": false,
          "sort_field": SortField.created.name,
          "sort_reverse": true,
          "filter_rules": [
            {'rule_type': correspondentRule.value, 'value': "42"},
            {'rule_type': documentTypeRule.value, 'value': "69"},
            {'rule_type': includeTagsRule.value, 'value': "1"},
            {'rule_type': includeTagsRule.value, 'value': "2"},
            {'rule_type': excludeTagsRule.value, 'value': "3"},
            {'rule_type': excludeTagsRule.value, 'value': "4"},
            {
              'rule_type': extendedRule.value,
              'value': "Never gonna give you up",
            },
            {'rule_type': storagePathRule.value, 'value': "14"},
            {'rule_type': createdBeforeRule, 'value': "2022-10-27"},
            {'rule_type': createdAfterRule, 'value': "2022-09-27"},
            {'rule_type': addedBeforeRule.value, 'value': "2022-09-26"},
            {'rule_type': addedAfterRule.value, 'value': "2000-01-01"},
          ],
        }).toDocumentFilter(),
        equals(
          DocumentFilter(
            correspondent: const SetIdQueryParameter(id: 42),
            documentType: const SetIdQueryParameter(id: 69),
            storagePath: const SetIdQueryParameter(id: 14),
            tags: const IdsTagsQuery(include: [1, 2], exclude: [3, 4]),
            created: AbsoluteDateRangeQuery(
              before: DateTime.parse("2022-10-27"),
              after: DateTime.parse("2022-09-27"),
            ),
            added: AbsoluteDateRangeQuery(
              before: DateTime.parse("2022-09-26"),
              after: DateTime.parse("2000-01-01"),
            ),
            sortField: SortField.created,
            sortOrder: SortOrder.descending,
            query: const TextQuery.extended("Never gonna give you up"),
            selectedView: 1,
          ),
        ),
      );
    });

    test('Values are correctly parsed if unset.', () {
      expect(
        SavedView.fromJson({
          "id": 1,
          "name": "test_name",
          "show_on_dashboard": false,
          "show_in_sidebar": false,
          "sort_field": SortField.created.name,
          "sort_reverse": true,
          "filter_rules": [],
        }).toDocumentFilter(),
        equals(const DocumentFilter(selectedView: 1)),
      );
    });

    test('Values are correctly parsed if not assigned.', () {
      final actual = SavedView.fromJson({
        "id": 1,
        "name": "test_name",
        "show_on_dashboard": false,
        "show_in_sidebar": false,
        "sort_field": SortField.created.name,
        "sort_reverse": true,
        "filter_rules": [
          {'rule_type': correspondentRule, 'value': null},
          {'rule_type': documentTypeRule, 'value': null},
          {'rule_type': hasAnyTag, 'value': false.toString()},
          {'rule_type': storagePathRule, 'value': null},
        ],
      }).toDocumentFilter();
      const expected = DocumentFilter(
        correspondent: NotAssignedIdQueryParameter(),
        documentType: NotAssignedIdQueryParameter(),
        storagePath: NotAssignedIdQueryParameter(),
        tags: NotAssignedTagsQuery(),
        selectedView: 1,
      );
      expect(actual, equals(expected));
    });
  });

  group('Validate parsing logic from [DocumentFilter] to [SavedView]:', () {
    test('Values are correctly parsed if set.', () {
      expect(
        DocumentFilter(
          selectedView: 1,
          correspondent: const SetIdQueryParameter(id: 1),
          documentType: const SetIdQueryParameter(id: 2),
          storagePath: const SetIdQueryParameter(id: 3),
          tags: const IdsTagsQuery(include: [4, 5], exclude: [6, 7, 8]),
          sortField: SortField.added,
          sortOrder: SortOrder.ascending,
          created: AbsoluteDateRangeQuery(
            before: DateTime.parse("2020-04-01"),
            after: DateTime.parse("2020-02-01"),
          ),
          added: AbsoluteDateRangeQuery(
            before: DateTime.parse("2020-03-01"),
            after: DateTime.parse("2020-01-01"),
          ),
          query: const TextQuery.title("Never gonna let you down"),
        ).toSavedViewRequest(
          name: "test_name",
          showInSidebar: false,
          showOnDashboard: false,
        ),
        equals(
          SavedView(
            id: 1,
            name: "test_name",
            showOnDashboard: false,
            showInSidebar: false,
            sortField: SortField.added.queryString,
            sortReverse: false,
            userCanChange: true,
            filterRules: [
              SavedViewFilterRule(ruleType: correspondentRule, value: "1"),
              SavedViewFilterRule(ruleType: documentTypeRule, value: "2"),
              SavedViewFilterRule(ruleType: storagePathRule, value: "3"),
              SavedViewFilterRule(ruleType: includeTagsRule, value: "4"),
              SavedViewFilterRule(ruleType: includeTagsRule, value: "5"),
              SavedViewFilterRule(ruleType: excludeTagsRule, value: "6"),
              SavedViewFilterRule(ruleType: excludeTagsRule, value: "7"),
              SavedViewFilterRule(ruleType: excludeTagsRule, value: "8"),
              SavedViewFilterRule(
                ruleType: addedAfterRule,
                value: "2020-01-01",
              ),
              SavedViewFilterRule(
                ruleType: addedBeforeRule,
                value: "2020-03-01",
              ),
              SavedViewFilterRule(
                ruleType: createdAfterRule,
                value: "2020-02-01",
              ),
              SavedViewFilterRule(
                ruleType: createdBeforeRule,
                value: "2020-04-01",
              ),
              SavedViewFilterRule(
                ruleType: titleRule,
                value: "Never gonna let you down",
              ),
            ],
          ),
        ),
      );
    });

    test('Values are correctly parsed if unset.', () {
      expect(
        const DocumentFilter(
          correspondent: UnsetIdQueryParameter(),
          documentType: UnsetIdQueryParameter(),
          storagePath: UnsetIdQueryParameter(),
          tags: IdsTagsQuery(),
          sortField: SortField.created,
          sortOrder: SortOrder.descending,
          added: UnsetDateRangeQuery(),
          created: UnsetDateRangeQuery(),
          query: TextQuery(),
        ).toSavedViewRequest(
          name: "test_name",
          showInSidebar: false,
          showOnDashboard: false,
        ),
        equals(
          SavedViewRequest(
            name: "test_name",
            showOnDashboard: false,
            showInSidebar: false,
            sortField: SortField.created.queryString,
            sortReverse: true,
            filterRules: [],
          ),
        ),
      );
    });

    test('Values are correctly parsed if not assigned.', () {
      expect(
        const DocumentFilter(
          correspondent: NotAssignedIdQueryParameter(),
          documentType: NotAssignedIdQueryParameter(),
          storagePath: NotAssignedIdQueryParameter(),
          tags: NotAssignedTagsQuery(),
          sortField: SortField.created,
          sortOrder: SortOrder.ascending,
        ).toSavedViewRequest(
          name: "test_name",
          showInSidebar: false,
          showOnDashboard: false,
        ),
        equals(
          SavedViewRequest(
            name: "test_name",
            showOnDashboard: false,
            showInSidebar: false,
            sortField: SortField.created.queryString,
            sortReverse: false,
            filterRules: [
              SavedViewFilterRuleRequest(
                ruleType: correspondentRule,
                value: null,
              ),
              SavedViewFilterRuleRequest(
                ruleType: documentTypeRule,
                value: null,
              ),
              SavedViewFilterRuleRequest(
                ruleType: storagePathRule,
                value: null,
              ),
              SavedViewFilterRuleRequest(
                ruleType: hasAnyTag,
                value: false.toString(),
              ),
            ],
          ),
        ),
      );
    });
  });
}

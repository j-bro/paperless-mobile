import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_api/paperless_api.dart';

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
            {'rule_type': RuleTypeEnum.correspondentIs.value, 'value': "42"},
            {'rule_type': RuleTypeEnum.documentTypeIs.value, 'value': "69"},
            {'rule_type': RuleTypeEnum.hasTag.value, 'value': "1"},
            {'rule_type': RuleTypeEnum.hasTag.value, 'value': "2"},
            {'rule_type': RuleTypeEnum.doesNotHaveTag.value, 'value': "3"},
            {'rule_type': RuleTypeEnum.doesNotHaveTag.value, 'value': "4"},
            {
              'rule_type': RuleTypeEnum.fulltextQuery.value,
              'value': "Never gonna give you up",
            },
            {'rule_type': RuleTypeEnum.storagePathIs.value, 'value': "14"},
            {'rule_type': RuleTypeEnum.createdBefore, 'value': "2022-10-27"},
            {'rule_type': RuleTypeEnum.createdAfter, 'value': "2022-09-27"},
            {'rule_type': RuleTypeEnum.addedBefore, 'value': "2022-09-26"},
            {'rule_type': RuleTypeEnum.addedAfter, 'value': "2000-01-01"},
          ],
        }).toDocumentFilter(),
        equals(
          DocumentFilter(
            correspondent: IdQueryParameter.include(ids: [42]),
            documentType: IdQueryParameter.include(ids: [69]),
            storagePath: IdQueryParameter.include(ids: [14]),
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
          {'rule_type': RuleTypeEnum.correspondentIs, 'value': null},
          {'rule_type': RuleTypeEnum.documentTypeIs, 'value': null},
          {'rule_type': RuleTypeEnum.hasAnyTag, 'value': false.toString()},
          {'rule_type': RuleTypeEnum.storagePathIs, 'value': null},
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
          correspondent: const IdQueryParameter.include(ids: [1]),
          documentType: const IdQueryParameter.include(ids: [2]),
          storagePath: const IdQueryParameter.include(ids: [3]),
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
            sortField: SortField.added.value,
            sortReverse: false,
            userCanChange: true,
            filterRules: [
              SavedViewFilterRule(
                ruleType: RuleTypeEnum.correspondentIs,
                value: "1",
              ),
              SavedViewFilterRule(
                ruleType: RuleTypeEnum.documentTypeIs,
                value: "2",
              ),
              SavedViewFilterRule(
                ruleType: RuleTypeEnum.storagePathIs,
                value: "3",
              ),
              SavedViewFilterRule(ruleType: RuleTypeEnum.hasTag, value: "4"),
              SavedViewFilterRule(ruleType: RuleTypeEnum.hasTag, value: "5"),
              SavedViewFilterRule(
                ruleType: RuleTypeEnum.doesNotHaveTag,
                value: "6",
              ),
              SavedViewFilterRule(
                ruleType: RuleTypeEnum.doesNotHaveTag,
                value: "7",
              ),
              SavedViewFilterRule(
                ruleType: RuleTypeEnum.doesNotHaveTag,
                value: "8",
              ),
              SavedViewFilterRule(
                ruleType: RuleTypeEnum.addedAfter,
                value: "2020-01-01",
              ),
              SavedViewFilterRule(
                ruleType: RuleTypeEnum.addedBefore,
                value: "2020-03-01",
              ),
              SavedViewFilterRule(
                ruleType: RuleTypeEnum.createdAfter,
                value: "2020-02-01",
              ),
              SavedViewFilterRule(
                ruleType: RuleTypeEnum.createdBefore,
                value: "2020-04-01",
              ),
              SavedViewFilterRule(
                ruleType: RuleTypeEnum.titleContains,
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
          correspondent: IdQueryParameter.unset(),
          documentType: IdQueryParameter.unset(),
          storagePath: IdQueryParameter.unset(),
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
            sortField: SortField.created.value,
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
            sortField: SortField.created.value,
            sortReverse: false,
            filterRules: [
              SavedViewFilterRuleRequest(
                ruleType: RuleTypeEnum.correspondentIs,
                value: null,
              ),
              SavedViewFilterRuleRequest(
                ruleType: RuleTypeEnum.documentTypeIs,
                value: null,
              ),
              SavedViewFilterRuleRequest(
                ruleType: RuleTypeEnum.storagePathIs,
                value: null,
              ),
              SavedViewFilterRuleRequest(
                ruleType: RuleTypeEnum.hasAnyTag,
                value: false.toString(),
              ),
            ],
          ),
        ),
      );
    });
  });
}

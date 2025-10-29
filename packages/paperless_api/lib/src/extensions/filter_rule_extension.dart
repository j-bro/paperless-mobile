import 'package:paperless_api/generated/lib/src/model/saved_view_filter_rule.dart';
import 'package:paperless_api/src/constants.dart';
import 'package:paperless_api/src/constants/filter_rules.dart';
import 'package:paperless_api/src/converters/local_date_time_json_converter.dart';
import 'package:paperless_api/src/models/document_filter.dart';
import 'package:paperless_api/src/models/query_parameters/date_range_queries/date_range_query.dart';
import 'package:paperless_api/src/models/query_parameters/date_range_queries/date_range_query_field.dart';
import 'package:paperless_api/src/models/query_parameters/id_query_parameter.dart';
import 'package:paperless_api/src/models/query_parameters/query_type.dart';
import 'package:paperless_api/src/models/query_parameters/tags_query/tags_query.dart';
import 'package:paperless_api/src/models/query_parameters/text_query.dart';

import '../models/query_parameters/date_range_queries/date_range_unit.dart';

extension FilterRuleToDocumentFilterExtension on SavedViewFilterRule {
  static const _dateTimeConverter = LocalDateTimeJsonConverter();

  DocumentFilter applyToFilter(final DocumentFilter filter) {
    switch (ruleType) {
      case titleRule:
        return filter.copyWith(query: TextQuery.title(value));
      case documentTypeRule:
        return filter.copyWith(
          documentType: value == null
              ? const NotAssignedIdQueryParameter()
              : SetIdQueryParameter(id: int.parse(value!)),
        );
      case correspondentRule:
        return filter.copyWith(
          correspondent: value == null
              ? const NotAssignedIdQueryParameter()
              : SetIdQueryParameter(id: int.parse(value!)),
        );
      case storagePathRule:
        return filter.copyWith(
          storagePath: value == null
              ? const NotAssignedIdQueryParameter()
              : SetIdQueryParameter(id: int.parse(value!)),
        );
      case hasAnyTag:
        return filter.copyWith(
          tags: value == "true"
              ? const AnyAssignedTagsQuery()
              : const NotAssignedTagsQuery(),
        );
      case includeTagsRule:
        assert(filter.tags is IdsTagsQuery);
        return filter.copyWith(
          tags: switch (filter.tags) {
            IdsTagsQuery(include: var i, exclude: var e) => IdsTagsQuery(
              include: [...i, int.parse(value!)],
              exclude: e,
            ),
            _ => filter.tags,
          },
        );
      case excludeTagsRule:
        assert(filter.tags is IdsTagsQuery);
        return filter.copyWith(
          tags: switch (filter.tags) {
            IdsTagsQuery(include: var i, exclude: var e) => IdsTagsQuery(
              include: i,
              exclude: [...e, int.parse(value!)],
            ),
            _ => filter.tags,
          },
        );
      case createdBeforeRule:
        if (filter.created is AbsoluteDateRangeQuery) {
          return filter.copyWith(
            created: (filter.created as AbsoluteDateRangeQuery).copyWith(
              before: _dateTimeConverter.fromJson(value!),
            ),
          );
        } else {
          return filter.copyWith(
            created: AbsoluteDateRangeQuery(
              before: _dateTimeConverter.fromJson(value!),
            ),
          );
        }
      case createdAfterRule:
        if (filter.created is AbsoluteDateRangeQuery) {
          return filter.copyWith(
            created: (filter.created as AbsoluteDateRangeQuery).copyWith(
              after: _dateTimeConverter.fromJson(value!),
            ),
          );
        } else {
          return filter.copyWith(
            created: AbsoluteDateRangeQuery(
              after: _dateTimeConverter.fromJson(value!),
            ),
          );
        }
      case addedBeforeRule:
        if (filter.added is AbsoluteDateRangeQuery) {
          return filter.copyWith(
            added: (filter.added as AbsoluteDateRangeQuery).copyWith(
              before: _dateTimeConverter.fromJson(value!),
            ),
          );
        } else {
          return filter.copyWith(
            added: AbsoluteDateRangeQuery(
              before: _dateTimeConverter.fromJson(value!),
            ),
          );
        }
      case addedAfterRule:
        if (filter.added is AbsoluteDateRangeQuery) {
          return filter.copyWith(
            added: (filter.added as AbsoluteDateRangeQuery).copyWith(
              after: _dateTimeConverter.fromJson(value!),
            ),
          );
        } else {
          return filter.copyWith(
            added: AbsoluteDateRangeQuery(
              after: _dateTimeConverter.fromJson(value!),
            ),
          );
        }
      case modifiedBeforeRule:
        if (filter.modified is AbsoluteDateRangeQuery) {
          return filter.copyWith(
            modified: (filter.modified as AbsoluteDateRangeQuery).copyWith(
              before: _dateTimeConverter.fromJson(value!),
            ),
          );
        } else {
          return filter.copyWith(
            modified: AbsoluteDateRangeQuery(
              before: _dateTimeConverter.fromJson(value!),
            ),
          );
        }
      case modifiedAfterRule:
        if (filter.modified is AbsoluteDateRangeQuery) {
          return filter.copyWith(
            modified: (filter.modified as AbsoluteDateRangeQuery).copyWith(
              after: _dateTimeConverter.fromJson(value!),
            ),
          );
        } else {
          return filter.copyWith(
            added: AbsoluteDateRangeQuery(
              after: _dateTimeConverter.fromJson(value!),
            ),
          );
        }
      case titleAndContentRule:
        return filter.copyWith(query: TextQuery.titleAndContent(value));
      case extendedRule:
        return _parseExtendedRule(filter);
      default:
        return filter;
    }
  }

  DocumentFilter _parseExtendedRule(DocumentFilter filter) {
    assert(value != null);
    final extendedQueryValues = value!.split(",").reversed;

    for (final query in extendedQueryValues) {
      if (RegExp(lastNDateRangeQueryRegex).hasMatch(query)) {
        filter = _parseRelativeDateRangeQuery(query, filter);
      } else {
        filter = filter.copyWith(query: TextQuery.extended(query));
      }
    }
    return filter;
  }

  DocumentFilter _parseRelativeDateRangeQuery(
    String query,
    final DocumentFilter filter,
  ) {
    DocumentFilter newFilter = filter;
    final matches = RegExp(lastNDateRangeQueryRegex).allMatches(query);
    for (final match in matches) {
      final field = match.namedGroup('field')!;
      final n = int.parse(match.namedGroup('n')!);
      final unit = match.namedGroup('unit')!;
      switch (field) {
        case 'created':
          newFilter = newFilter.copyWith(
            created: RelativeDateRangeQuery(
              n,
              DateRangeUnit.values.byName(unit),
            ),
            query: newFilter.query.copyWith(queryType: QueryType.extended),
          );
          break;
        case 'added':
          newFilter = newFilter.copyWith(
            added: RelativeDateRangeQuery(n, DateRangeUnit.values.byName(unit)),
            query: newFilter.query.copyWith(queryType: QueryType.extended),
          );
          break;
        case 'modified':
          newFilter = newFilter.copyWith(
            modified: RelativeDateRangeQuery(
              n,
              DateRangeUnit.values.byName(unit),
            ),
            query: newFilter.query.copyWith(queryType: QueryType.extended),
          );
          break;
      }
    }
    return newFilter;
  }
}

extension ToFilterRuleExtension on DocumentFilter {
  ///
  /// Converts a [DocumentFilter] to a list of [FilterRule]s.
  ///
  List<SavedViewFilterRule> toFilterRules() {
    List<SavedViewFilterRule> filterRules = [];
    final corrRule = switch (correspondent) {
      NotAssignedIdQueryParameter() => SavedViewFilterRule(
        ruleType: correspondentRule,
        value: null,
      ),
      SetIdQueryParameter(id: var id) => SavedViewFilterRule(
        ruleType: correspondentRule,
        value: id.toString(),
      ),
      _ => null,
    };
    if (corrRule != null) {
      filterRules.add(corrRule);
    }

    final docTypeRule = switch (documentType) {
      NotAssignedIdQueryParameter() => SavedViewFilterRule(
        ruleType: documentTypeRule,
        value: null,
      ),
      SetIdQueryParameter(id: var id) => SavedViewFilterRule(
        ruleType: documentTypeRule,
        value: id.toString(),
      ),
      _ => null,
    };

    if (docTypeRule != null) {
      filterRules.add(docTypeRule);
    }

    final sPathRule = switch (storagePath) {
      NotAssignedIdQueryParameter() => SavedViewFilterRule(
        ruleType: storagePathRule,
        value: null,
      ),
      SetIdQueryParameter(id: var id) => SavedViewFilterRule(
        ruleType: storagePathRule,
        value: id.toString(),
      ),
      _ => null,
    };

    if (sPathRule != null) {
      filterRules.add(sPathRule);
    }
    final tagRules = switch (tags) {
      NotAssignedTagsQuery() => [
        SavedViewFilterRule(ruleType: hasAnyTag, value: 'false'),
      ],
      AnyAssignedTagsQuery() => [
        SavedViewFilterRule(ruleType: hasAnyTag, value: 'true'),
      ],
      IdsTagsQuery(include: var i, exclude: var e) => [
        ...i.map(
          (id) => SavedViewFilterRule(
            ruleType: includeTagsRule,
            value: id.toString(),
          ),
        ),
        ...e.map(
          (id) => SavedViewFilterRule(
            ruleType: excludeTagsRule,
            value: id.toString(),
          ),
        ),
      ],
    };

    filterRules.addAll(tagRules);

    if (query.queryText != null) {
      switch (query.queryType) {
        case QueryType.title:
          filterRules.add(
            SavedViewFilterRule(ruleType: titleRule, value: query.queryText!),
          );
          break;
        case QueryType.titleAndContent:
          filterRules.add(
            SavedViewFilterRule(
              ruleType: titleAndContentRule,
              value: query.queryText!,
            ),
          );
          break;
        case QueryType.extended:
          filterRules.add(
            SavedViewFilterRule(
              ruleType: extendedRule,
              value: query.queryText!,
            ),
          );
          break;
        case QueryType.asn:
          filterRules.add(
            SavedViewFilterRule(ruleType: asnRule, value: query.queryText!),
          );
          break;
      }
    }

    // Parse created at
    switch (created) {
      case AbsoluteDateRangeQuery(after: var after, before: var before):
        if (after != null) {
          filterRules.add(
            SavedViewFilterRule(
              ruleType: createdAfterRule,
              value: apiDateFormat.format(after),
            ),
          );
        }
        if (before != null) {
          filterRules.add(
            SavedViewFilterRule(
              ruleType: createdBeforeRule,
              value: apiDateFormat.format(before),
            ),
          );
        }
        break;
      case RelativeDateRangeQuery():
        filterRules.add(
          SavedViewFilterRule(
            ruleType: extendedRule,
            value: created
                .toQueryParameter(DateRangeQueryField.created)
                .values
                .first,
          ),
        );
        break;
      default:
        break;
    }

    // Parse added at
    switch (added) {
      case AbsoluteDateRangeQuery(after: var after, before: var before):
        if (after != null) {
          filterRules.add(
            SavedViewFilterRule(
              ruleType: addedAfterRule,
              value: apiDateFormat.format(after),
            ),
          );
        }
        if (before != null) {
          filterRules.add(
            SavedViewFilterRule(
              ruleType: addedBeforeRule,
              value: apiDateFormat.format(before),
            ),
          );
        }
        break;
      case RelativeDateRangeQuery():
        filterRules.add(
          SavedViewFilterRule(
            ruleType: extendedRule,
            value: added
                .toQueryParameter(DateRangeQueryField.added)
                .values
                .first,
          ),
        );
        break;
      default:
        break;
    }

    // Parse modified at
    switch (modified) {
      case AbsoluteDateRangeQuery(after: var after, before: var before):
        if (after != null) {
          filterRules.add(
            SavedViewFilterRule(
              ruleType: modifiedAfterRule,
              value: apiDateFormat.format(after),
            ),
          );
        }
        if (before != null) {
          filterRules.add(
            SavedViewFilterRule(
              ruleType: modifiedBeforeRule,
              value: apiDateFormat.format(before),
            ),
          );
        }
        break;
      case RelativeDateRangeQuery():
        filterRules.add(
          SavedViewFilterRule(
            ruleType: extendedRule,
            value: modified
                .toQueryParameter(DateRangeQueryField.modified)
                .values
                .first,
          ),
        );
        break;
      default:
        break;
    }

    //Join values of all extended filter rules if exist
    if (filterRules.where((e) => e.ruleType == extendedRule).isNotEmpty) {
      final mergedExtendedRule = filterRules
          .where((r) => r.ruleType == extendedRule)
          .map((e) => e.value)
          .join(",");
      filterRules
        ..removeWhere((element) => element.ruleType == extendedRule)
        ..add(
          SavedViewFilterRule(
            ruleType: extendedRule,
            value: mergedExtendedRule,
          ),
        );
    }
    return filterRules;
  }
}

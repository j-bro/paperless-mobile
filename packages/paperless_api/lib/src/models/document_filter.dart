import 'package:collection/collection.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_api/paperless_api.dart';

part 'document_filter.g.dart';

@CopyWith()
@JsonSerializable()
class DocumentFilter extends Equatable {
  static const DocumentFilter initial = DocumentFilter();

  static const DocumentFilter latestDocument = DocumentFilter(
    sortField: SortField.added,
    sortOrder: SortOrder.descending,
    pageSize: 1,
    page: 1,
  );

  final int pageSize;
  final int page;
  final IdQueryParameter documentType;
  final IdQueryParameter correspondent;
  final IdQueryParameter storagePath;
  final IdQueryParameter archiveSerialNumber;
  final TagsQuery tags;
  final SortField? sortField;
  final SortOrder sortOrder;
  final DateRangeQuery created;
  final DateRangeQuery added;
  final DateRangeQuery modified;
  final TextQuery query;
  final int? moreLike;
  final int? selectedView;
  final List<String>? fields;

  const DocumentFilter({
    this.documentType = const UnsetIdQueryParameter(),
    this.correspondent = const UnsetIdQueryParameter(),
    this.storagePath = const UnsetIdQueryParameter(),
    this.archiveSerialNumber = const UnsetIdQueryParameter(),
    this.tags = const IdsTagsQuery(),
    this.sortField = SortField.created,
    this.sortOrder = SortOrder.descending,
    this.page = 1,
    this.pageSize = 25,
    this.query = const TextQuery(),
    this.added = const UnsetDateRangeQuery(),
    this.created = const UnsetDateRangeQuery(),
    this.modified = const UnsetDateRangeQuery(),
    this.moreLike,
    this.selectedView,
    this.fields,
  });

  bool get forceExtendedQuery {
    debugPrint(
      'forceExtendedQuery called ${added.runtimeType}, ${created.runtimeType}, ${modified.runtimeType}',
    );
    return added is RelativeDateRangeQuery ||
        created is RelativeDateRangeQuery ||
        modified is RelativeDateRangeQuery;
  }

  Map<String, dynamic> toQueryParameters() {
    List<MapEntry<String, dynamic>> params = [
      MapEntry('page', page),
      MapEntry('page_size', pageSize),
      ...documentType.toQueryParameter('document_type').entries,
      ...correspondent.toQueryParameter('correspondent').entries,
      ...storagePath.toQueryParameter('storage_path').entries,
      ...archiveSerialNumber.toQueryParameter('archive_serial_number').entries,
      ...tags.toQueryParameter().entries,
      ...added.toQueryParameter(DateRangeQueryField.added).entries,
      ...created.toQueryParameter(DateRangeQueryField.created).entries,
      ...modified.toQueryParameter(DateRangeQueryField.modified).entries,
      ...query.toQueryParameter().entries,
      if (sortField != null)
        MapEntry('ordering', '${sortOrder.queryString}${sortField!.value}'),
      if (moreLike != null) MapEntry('more_like_id', moreLike),
      if (fields != null) MapEntry('fields', fields),
    ];

    // Reverse ordering can also be encoded using &reverse=1
    // Merge query params
    final queryParams = groupBy(params, (e) => e.key).map(
      (key, entries) => MapEntry(
        key,
        entries.length == 1
            ? entries.first.value
            : entries.map((e) => e.value).join(","),
      ),
    );
    return queryParams;
  }

  int get appliedFiltersCount => [
    switch (documentType) {
      UnsetIdQueryParameter() => 0,
      _ => 1,
    },
    switch (correspondent) {
      UnsetIdQueryParameter() => 0,
      _ => 1,
    },
    switch (storagePath) {
      UnsetIdQueryParameter() => 0,
      _ => 1,
    },
    switch (tags) {
      NotAssignedTagsQuery() => 1,
      AnyAssignedTagsQuery(tagIds: var tags) => tags.length,
      IdsTagsQuery(include: var i, exclude: var e) => e.length + i.length,
    },
    switch (added) {
      RelativeDateRangeQuery() => 1,
      AbsoluteDateRangeQuery() => 1,
      UnsetDateRangeQuery() => 0,
    },
    switch (created) {
      RelativeDateRangeQuery() => 1,
      AbsoluteDateRangeQuery() => 1,
      UnsetDateRangeQuery() => 0,
    },
    switch (modified) {
      RelativeDateRangeQuery() => 1,
      AbsoluteDateRangeQuery() => 1,
      UnsetDateRangeQuery() => 0,
    },
    switch (archiveSerialNumber) {
      UnsetIdQueryParameter() => 0,
      _ => 1,
    },
    (query.queryText?.isNotEmpty ?? false) ? 1 : 0,
  ].fold(0, (previousValue, element) => previousValue + element);

  @override
  List<Object?> get props => [
    pageSize,
    page,
    documentType,
    correspondent,
    storagePath,
    archiveSerialNumber,
    tags,
    sortField,
    sortOrder,
    added,
    created,
    modified,
    query,
    moreLike,
    selectedView,
  ];

  Map<String, dynamic> toJson() => _$DocumentFilterToJson(this);

  factory DocumentFilter.fromJson(Map<String, dynamic> json) =>
      _$DocumentFilterFromJson(json);
}

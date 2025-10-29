// ignore_for_file: overridden_fields

import 'package:json_annotation/json_annotation.dart';

part 'get_filter_options.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class GetFilterOptions {
  final int? id;
  @JsonKey(name: 'ids__in')
  final Iterable<int>? ids;
  @JsonKey(name: 'name__icontains')
  final String? nameContains;
  @JsonKey(name: 'name__iendswith')
  final String? nameEndsWith;
  @JsonKey(name: 'name__istartswith')
  final String? nameStartsWith;
  @JsonKey(name: 'name__iexact')
  final String? nameExact;
  final String? ordering;
  final int? page;
  final int? pageSize;
  @JsonKey(name: 'full_perms')
  final bool? fullPermissions;

  const GetFilterOptions({
    this.id,
    this.ids,
    this.nameContains,
    this.nameEndsWith,
    this.nameStartsWith,
    this.nameExact,
    this.ordering,
    this.page = 1,
    this.pageSize = 100000,
    this.fullPermissions,
  });
  Map<String, dynamic> toJson() => _$GetFilterOptionsToJson(this);
}

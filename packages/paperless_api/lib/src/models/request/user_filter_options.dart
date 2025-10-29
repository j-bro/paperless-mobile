// ignore_for_file: overridden_fields

import 'package:json_annotation/json_annotation.dart';

part 'user_filter_options.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class UserFilterOptions {
  final int? id;
  @JsonKey(name: 'ids__in')
  final Iterable<int>? ids;
  @JsonKey(name: 'username__icontains')
  final String? usernameContains;
  @JsonKey(name: 'username__iendswith')
  final String? usernameEndsWith;
  @JsonKey(name: 'username__istartswith')
  final String? usernameStartsWith;
  @JsonKey(name: 'username__iexact')
  final String? usernameExact;
  final String? ordering;
  final int? page;
  final int? pageSize;
  const UserFilterOptions({
    this.id,
    this.ids,
    this.usernameContains,
    this.usernameEndsWith,
    this.usernameStartsWith,
    this.usernameExact,
    this.ordering,
    this.page = 1,
    this.pageSize = 100000,
  });
  Map<String, dynamic> toJson() => _$UserFilterOptionsToJson(this);
}

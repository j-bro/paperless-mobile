import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tags_query.g.dart';

sealed class TagsQuery with EquatableMixin {
  const TagsQuery();
  //TODO: This can be removed, we have to map the DocumentFilter to DocumentFilterOptions.
  Map<String, String> toQueryParameter();
  bool matches(Iterable<int> ids);
  Map<String, dynamic> toJson();

  factory TagsQuery.fromJson(Map<String, dynamic> json) {
    final type = json['__type'] as String?;
    switch (type) {
      case 'NotAssignedTagsQuery':
        return NotAssignedTagsQuery();
      case 'AnyAssignedTagsQuery':
        return AnyAssignedTagsQuery.fromJson(json);
      case 'IdsTagsQuery':
        return IdsTagsQuery.fromJson(json);
      default:
        throw UnimplementedError('Unknown TagsQuery type: $type');
    }
  }
}

@JsonSerializable()
class NotAssignedTagsQuery extends TagsQuery {
  @JsonKey(includeToJson: true, includeFromJson: false)
  final __type = 'NotAssignedTagsQuery';

  const NotAssignedTagsQuery();
  @override
  Map<String, String> toQueryParameter() {
    return {'is_tagged': '0'};
  }

  @override
  bool matches(Iterable<int> ids) => ids.isEmpty;

  @override
  List<Object?> get props => [];

  @override
  Map<String, dynamic> toJson() => _$NotAssignedTagsQueryToJson(this);

  factory NotAssignedTagsQuery.fromJson(Map<String, dynamic> json) {
    return _$NotAssignedTagsQueryFromJson(json);
  }
}

@CopyWith()
@JsonSerializable()
class AnyAssignedTagsQuery extends TagsQuery {
  @JsonKey(includeToJson: true, includeFromJson: false)
  final __type = 'AnyAssignedTagsQuery';

  final List<int> tagIds;

  const AnyAssignedTagsQuery({this.tagIds = const []});

  @override
  Map<String, String> toQueryParameter() {
    if (tagIds.isEmpty) {
      return {'is_tagged': '1'};
    }
    return {'tags__id__in': tagIds.join(',')};
  }

  @override
  bool matches(Iterable<int> ids) => ids.isNotEmpty;

  @override
  List<Object?> get props => [tagIds];

  @override
  Map<String, dynamic> toJson() => _$AnyAssignedTagsQueryToJson(this);

  factory AnyAssignedTagsQuery.fromJson(Map<String, dynamic> json) {
    return _$AnyAssignedTagsQueryFromJson(json);
  }
}

@CopyWith()
@JsonSerializable()
class IdsTagsQuery extends TagsQuery {
  @JsonKey(includeToJson: true, includeFromJson: false)
  final __type = 'IdsTagsQuery';

  final List<int> include;
  final List<int> exclude;

  const IdsTagsQuery({this.include = const [], this.exclude = const []});
  @override
  Map<String, String> toQueryParameter() {
    final Map<String, String> params = {};
    if (include.isNotEmpty) {
      params.putIfAbsent('tags__id__all', () => include.join(','));
    }
    if (exclude.isNotEmpty) {
      params.putIfAbsent('tags__id__none', () => exclude.join(','));
    }
    return params;
  }

  @override
  bool matches(Iterable<int> ids) {
    return include.toSet().difference(ids.toSet()).isEmpty &&
        exclude.toSet().intersection(ids.toSet()).isEmpty;
  }

  @override
  List<Object?> get props => [include, exclude];

  @override
  Map<String, dynamic> toJson() => _$IdsTagsQueryToJson(this);

  factory IdsTagsQuery.fromJson(Map<String, dynamic> json) {
    return _$IdsTagsQueryFromJson(json);
  }
}

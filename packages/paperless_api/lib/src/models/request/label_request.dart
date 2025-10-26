// ignore_for_file: overridden_fields

import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/paperless_api.dart';

part 'label_request.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class LabelPatchRequest {
  @JsonKey(includeToJson: false)
  final int id;
  covariant String? name;
  final String? match;
  final MatchingAlgorithm? matchingAlgorithm;
  final bool? isInsensitive;
  final int? owner;
  final SetPermissions? permissions;

  LabelPatchRequest({
    required this.id,
    this.name,
    this.match,
    this.matchingAlgorithm,
    this.isInsensitive,
    this.owner,
    this.permissions,
  });

  Map<String, dynamic> toJson() => _$LabelPatchRequestToJson(this);
}

@JsonSerializable(createFactory: false, includeIfNull: true)
class LabelRequest extends LabelPatchRequest {
  @override
  final String name;

  LabelRequest({
    required super.id,
    required this.name,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.owner,
    super.permissions,
  });

  @override
  Map<String, dynamic> toJson() => _$LabelRequestToJson(this);
}

@JsonSerializable(createFactory: false, includeIfNull: false)
class TagPatchRequest extends LabelPatchRequest {
  TagPatchRequest({
    required super.id,
    super.name,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.owner,
    super.permissions,
  });

  @override
  Map<String, dynamic> toJson() => _$TagPatchRequestToJson(this);
}

@JsonSerializable(createFactory: false, includeIfNull: true)
class TagRequest extends TagPatchRequest {
  final bool? isInboxTag;
  TagRequest({
    required super.id,
    required super.name,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.owner,
    super.permissions,
    this.isInboxTag,
  });

  @override
  Map<String, dynamic> toJson() => _$TagRequestToJson(this);
}

@JsonSerializable(createFactory: false, includeIfNull: true)
class StoragePathRequest extends LabelRequest {
  final String path;

  StoragePathRequest({
    required super.id,
    required super.name,
    required this.path,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.owner,
    super.permissions,
  });

  @override
  Map<String, dynamic> toJson() => _$StoragePathRequestToJson(this);
}

@JsonSerializable(createFactory: false, includeIfNull: false)
class StoragePathPatchRequest extends LabelPatchRequest {
  final String? path;

  StoragePathPatchRequest({
    required super.id,
    super.name,
    this.path,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.owner,
    super.permissions,
  });

  @override
  Map<String, dynamic> toJson() => _$StoragePathPatchRequestToJson(this);
}

@JsonSerializable(createFactory: false, includeIfNull: false)
class LabelGetOptions {
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

  const LabelGetOptions({
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
  Map<String, dynamic> toJson() => _$LabelGetOptionsToJson(this);
}

extension LabelRequestExtension on Label {
  LabelRequest toPutRequest() {
    return LabelRequest(
      id: id,
      name: name,
      matchingAlgorithm: matchingAlgorithm,
      match: match,
      isInsensitive: isInsensitive,
      owner: owner,
    );
  }

  LabelPatchRequest toPatchRequest() {
    return LabelPatchRequest(
      id: id,
      name: name,
      matchingAlgorithm: matchingAlgorithm,
      match: match,
      isInsensitive: isInsensitive,
      owner: owner,
    );
  }
}

extension TagRequestExtension on Tag {
  TagRequest toPutRequest() {
    return TagRequest(
      id: id,
      name: name,
      matchingAlgorithm: matchingAlgorithm,
      match: match,
      isInsensitive: isInsensitive,
      owner: owner,
    );
  }

  TagPatchRequest toPatchRequest() {
    return TagPatchRequest(
      id: id,
      name: name,
      matchingAlgorithm: matchingAlgorithm,
      match: match,
      isInsensitive: isInsensitive,
      owner: owner,
    );
  }
}

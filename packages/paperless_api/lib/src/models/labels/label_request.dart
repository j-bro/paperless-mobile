import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/generated/lib/src/model/correspondent_request_set_permissions.dart';
import 'package:paperless_api/src/converters/hex_color_json_converter.dart';
import 'package:paperless_api/src/models/models.dart';

part 'label_request.g.dart';

sealed class LabelRequest {
  LabelRequest({
    required this.name,
    this.match,
    this.matchingAlgorithm,
    this.isInsensitive,
    this.owner,
    this.setPermissions,
  });

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'match', required: false, includeIfNull: false)
  final String? match;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'matching_algorithm', required: false, includeIfNull: false)
  final MatchingAlgorithm? matchingAlgorithm;

  @JsonKey(name: r'is_insensitive', required: false, includeIfNull: false)
  final bool? isInsensitive;

  @JsonKey(name: r'owner', required: false, includeIfNull: false)
  final int? owner;
  @JsonKey(name: r'set_permissions', required: false, includeIfNull: false)
  final CorrespondentRequestSetPermissions? setPermissions;

  Map<String, dynamic> toJson();
}

@CopyWith()
@JsonSerializable(
  checked: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CorrespondentRequest extends LabelRequest {
  CorrespondentRequest({
    required super.name,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.owner,
    super.setPermissions,
  });

  @override
  Map<String, dynamic> toJson() => _$CorrespondentRequestToJson(this);
  factory CorrespondentRequest.fromJson(Map<String, dynamic> json) =>
      _$CorrespondentRequestFromJson(json);
}

@CopyWith()
@JsonSerializable(
  checked: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TagRequest extends LabelRequest {
  TagRequest({
    required super.name,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.owner,
    super.setPermissions,
    this.isInboxTag,
    this.color,
  });

  @JsonKey(name: r'color', required: false, includeIfNull: false)
  final String? color;

  /// Marks this tag as an inbox tag: All newly consumed documents will be tagged with inbox tags.
  @JsonKey(name: r'is_inbox_tag', required: false, includeIfNull: false)
  final bool? isInboxTag;

  @override
  Map<String, dynamic> toJson() => _$TagRequestToJson(this);
  factory TagRequest.fromJson(Map<String, dynamic> json) =>
      _$TagRequestFromJson(json);
}

@CopyWith()
@JsonSerializable(
  checked: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DocumentTypeRequest extends LabelRequest {
  DocumentTypeRequest({
    required super.name,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.owner,
    super.setPermissions,
  });

  @override
  Map<String, dynamic> toJson() => _$DocumentTypeRequestToJson(this);
  factory DocumentTypeRequest.fromJson(Map<String, dynamic> json) =>
      _$DocumentTypeRequestFromJson(json);
}

@CopyWith()
@JsonSerializable(
  checked: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StoragePathRequest extends LabelRequest {
  StoragePathRequest({
    required super.name,
    required this.path,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.owner,
    super.setPermissions,
  });

  @JsonKey(name: r'path', required: true, includeIfNull: false)
  final String path;

  @override
  Map<String, dynamic> toJson() => _$StoragePathRequestToJson(this);
  factory StoragePathRequest.fromJson(Map<String, dynamic> json) =>
      _$StoragePathRequestFromJson(json);
}

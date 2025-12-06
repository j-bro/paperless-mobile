import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/generated/lib/src/model/correspondent_request_set_permissions.dart';
import 'package:paperless_api/src/models/models.dart';

part 'patched_label_request.g.dart';

sealed class PatchedLabelRequest {
  PatchedLabelRequest({
    this.name,
    this.match,
    this.matchingAlgorithm,
    this.isInsensitive,
    this.owner,
    this.setPermissions,
  });

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String? name;

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
  createToJson: true,
  explicitToJson: true,
  createFactory: false,
)
class PatchedCorrespondentRequest extends PatchedLabelRequest {
  PatchedCorrespondentRequest({
    required super.name,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.owner,
    super.setPermissions,
  });
  @override
  Map<String, dynamic> toJson() => _$PatchedCorrespondentRequestToJson(this);
}

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  explicitToJson: true,
  createFactory: false,
)
class PatchedTagRequest extends PatchedLabelRequest {
  PatchedTagRequest({
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
  Map<String, dynamic> toJson() => _$PatchedTagRequestToJson(this);
}

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  explicitToJson: true,
  createFactory: false,
)
class PatchedDocumentTypeRequest extends PatchedLabelRequest {
  PatchedDocumentTypeRequest({
    required super.name,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.owner,
    super.setPermissions,
  });

  @override
  Map<String, dynamic> toJson() => _$PatchedDocumentTypeRequestToJson(this);
}

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  explicitToJson: true,
  createFactory: false,
)
class PatchedStoragePathRequest extends PatchedLabelRequest {
  PatchedStoragePathRequest({
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
  Map<String, dynamic> toJson() => _$PatchedStoragePathRequestToJson(this);
}

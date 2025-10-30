//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/matching_algorithm.dart';
import 'package:paperless_api/generated/lib/src/model/correspondent_request_set_permissions.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'tag_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TagRequest {
  /// Returns a new [TagRequest] instance.
  TagRequest({
    required this.name,

    this.color,

    this.match,

    this.matchingAlgorithm,

    this.isInsensitive,

    this.isInboxTag,

    this.owner,

    this.setPermissions,
  });

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'color', required: false, includeIfNull: false)
  final String? color;

  @JsonKey(name: r'match', required: false, includeIfNull: false)
  final String? match;

  // minimum: 0.0
  // maximum: 2.147483647E9
  @JsonKey(name: r'matching_algorithm', required: false, includeIfNull: false)
  final MatchingAlgorithm? matchingAlgorithm;

  @JsonKey(name: r'is_insensitive', required: false, includeIfNull: false)
  final bool? isInsensitive;

  /// Marks this tag as an inbox tag: All newly consumed documents will be tagged with inbox tags.
  @JsonKey(name: r'is_inbox_tag', required: false, includeIfNull: false)
  final bool? isInboxTag;

  @JsonKey(name: r'owner', required: false, includeIfNull: false)
  final int? owner;

  @JsonKey(name: r'set_permissions', required: false, includeIfNull: false)
  final CorrespondentRequestSetPermissions? setPermissions;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TagRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [
                name,
                color,
                match,
                matchingAlgorithm,
                isInsensitive,
                isInboxTag,
                owner,
                setPermissions,
              ],
              [
                other.name,
                other.color,
                other.match,
                other.matchingAlgorithm,
                other.isInsensitive,
                other.isInboxTag,
                other.owner,
                other.setPermissions,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        name,
        color,
        match,
        matchingAlgorithm,
        isInsensitive,
        isInboxTag,
        owner,
        setPermissions,
      ]);

  factory TagRequest.fromJson(Map<String, dynamic> json) =>
      _$TagRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TagRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

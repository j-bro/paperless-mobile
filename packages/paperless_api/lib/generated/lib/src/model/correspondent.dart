//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/correspondent_permissions.dart';
import 'package:paperless_api/generated/lib/src/model/matching_algorithm.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'correspondent.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Correspondent {
  /// Returns a new [Correspondent] instance.
  Correspondent({
    required this.id,

    required this.slug,

    required this.name,

    this.match,

    this.matchingAlgorithm,

    this.isInsensitive,

    required this.documentCount,

    required this.lastCorrespondence,

    this.owner,

    required this.permissions,

    required this.userCanChange,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'slug', required: true, includeIfNull: false)
  final String slug;

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

  @JsonKey(name: r'document_count', required: true, includeIfNull: false)
  final int documentCount;

  @JsonKey(name: r'last_correspondence', required: true, includeIfNull: false)
  final DateTime lastCorrespondence;

  @JsonKey(name: r'owner', required: false, includeIfNull: false)
  final int? owner;

  @JsonKey(name: r'permissions', required: true, includeIfNull: false)
  final CorrespondentPermissions permissions;

  @JsonKey(name: r'user_can_change', required: true, includeIfNull: false)
  final bool userCanChange;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Correspondent &&
            runtimeType == other.runtimeType &&
            equals(
              [
                id,
                slug,
                name,
                match,
                matchingAlgorithm,
                isInsensitive,
                documentCount,
                lastCorrespondence,
                owner,
                permissions,
                userCanChange,
              ],
              [
                other.id,
                other.slug,
                other.name,
                other.match,
                other.matchingAlgorithm,
                other.isInsensitive,
                other.documentCount,
                other.lastCorrespondence,
                other.owner,
                other.permissions,
                other.userCanChange,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        id,
        slug,
        name,
        match,
        matchingAlgorithm,
        isInsensitive,
        documentCount,
        lastCorrespondence,
        owner,
        permissions,
        userCanChange,
      ]);

  factory Correspondent.fromJson(Map<String, dynamic> json) =>
      _$CorrespondentFromJson(json);

  Map<String, dynamic> toJson() => _$CorrespondentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

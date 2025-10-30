//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/matching_algorithm.dart';
import 'package:paperless_api/generated/lib/src/model/correspondent_request_set_permissions.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'document_type_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DocumentTypeRequest {
  /// Returns a new [DocumentTypeRequest] instance.
  DocumentTypeRequest({
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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DocumentTypeRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [
                name,
                match,
                matchingAlgorithm,
                isInsensitive,
                owner,
                setPermissions,
              ],
              [
                other.name,
                other.match,
                other.matchingAlgorithm,
                other.isInsensitive,
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
        match,
        matchingAlgorithm,
        isInsensitive,
        owner,
        setPermissions,
      ]);

  factory DocumentTypeRequest.fromJson(Map<String, dynamic> json) =>
      _$DocumentTypeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentTypeRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

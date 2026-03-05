//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_mobile/api/models/file_version_enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'share_link.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ShareLink {
  /// Returns a new [ShareLink] instance.
  ShareLink({
    required this.id,

    required this.created,

    this.expiration,

    required this.slug,

    this.document,

    this.fileVersion,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final int id;

  @JsonKey(name: r'created', required: true, includeIfNull: false)
  final DateTime created;

  @JsonKey(name: r'expiration', required: false, includeIfNull: false)
  final DateTime? expiration;

  @JsonKey(name: r'slug', required: true, includeIfNull: false)
  final String slug;

  @JsonKey(name: r'document', required: false, includeIfNull: false)
  final int? document;

  @JsonKey(name: r'file_version', required: false, includeIfNull: false)
  final FileVersionEnum? fileVersion;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ShareLink &&
            runtimeType == other.runtimeType &&
            equals(
              [id, created, expiration, slug, document, fileVersion],
              [
                other.id,
                other.created,
                other.expiration,
                other.slug,
                other.document,
                other.fileVersion,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        id,
        created,
        expiration,
        slug,
        document,
        fileVersion,
      ]);

  factory ShareLink.fromJson(Map<String, dynamic> json) =>
      _$ShareLinkFromJson(json);

  Map<String, dynamic> toJson() => _$ShareLinkToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

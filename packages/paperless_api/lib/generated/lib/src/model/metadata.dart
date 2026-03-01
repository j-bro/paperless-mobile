//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'metadata.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Metadata {
  /// Returns a new [Metadata] instance.
  Metadata({
    this.originalChecksum,

    this.originalSize,

    this.originalMimeType,

    this.mediaFilename,

    this.hasArchiveVersion,

    this.originalMetadata,

    this.archiveChecksum,

    this.archiveMediaFilename,

    this.originalFilename,

    this.archiveSize,

    this.archiveMetadata,

    this.lang,
  });

  @JsonKey(name: r'original_checksum', required: false, includeIfNull: false)
  final String? originalChecksum;

  @JsonKey(name: r'original_size', required: false, includeIfNull: false)
  final int? originalSize;

  @JsonKey(name: r'original_mime_type', required: false, includeIfNull: false)
  final String? originalMimeType;

  @JsonKey(name: r'media_filename', required: false, includeIfNull: false)
  final String? mediaFilename;

  @JsonKey(name: r'has_archive_version', required: false, includeIfNull: false)
  final bool? hasArchiveVersion;

  @JsonKey(name: r'original_metadata', required: false, includeIfNull: false)
  final List<Object>? originalMetadata;

  @JsonKey(name: r'archive_checksum', required: false, includeIfNull: false)
  final String? archiveChecksum;

  @JsonKey(
    name: r'archive_media_filename',
    required: false,
    includeIfNull: false,
  )
  final String? archiveMediaFilename;

  @JsonKey(name: r'original_filename', required: false, includeIfNull: false)
  final String? originalFilename;

  @JsonKey(name: r'archive_size', required: false, includeIfNull: false)
  final int? archiveSize;

  @JsonKey(name: r'archive_metadata', required: false, includeIfNull: false)
  final List<Object>? archiveMetadata;

  @JsonKey(name: r'lang', required: false, includeIfNull: false)
  final String? lang;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Metadata &&
            runtimeType == other.runtimeType &&
            equals(
              [
                originalChecksum,
                originalSize,
                originalMimeType,
                mediaFilename,
                hasArchiveVersion,
                originalMetadata,
                archiveChecksum,
                archiveMediaFilename,
                originalFilename,
                archiveSize,
                archiveMetadata,
                lang,
              ],
              [
                other.originalChecksum,
                other.originalSize,
                other.originalMimeType,
                other.mediaFilename,
                other.hasArchiveVersion,
                other.originalMetadata,
                other.archiveChecksum,
                other.archiveMediaFilename,
                other.originalFilename,
                other.archiveSize,
                other.archiveMetadata,
                other.lang,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        originalChecksum,
        originalSize,
        originalMimeType,
        mediaFilename,
        hasArchiveVersion,
        originalMetadata,
        archiveChecksum,
        archiveMediaFilename,
        originalFilename,
        archiveSize,
        archiveMetadata,
        lang,
      ]);

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

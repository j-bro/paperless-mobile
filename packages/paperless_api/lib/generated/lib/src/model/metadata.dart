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
    required this.originalChecksum,

    required this.originalSize,

    required this.originalMimeType,

    required this.mediaFilename,

    required this.hasArchiveVersion,

    required this.originalMetadata,

    required this.archiveChecksum,

    required this.archiveMediaFilename,

    required this.originalFilename,

    required this.archiveSize,

    required this.archiveMetadata,

    required this.lang,
  });

  @JsonKey(name: r'original_checksum', required: true, includeIfNull: false)
  final String originalChecksum;

  @JsonKey(name: r'original_size', required: true, includeIfNull: false)
  final int originalSize;

  @JsonKey(name: r'original_mime_type', required: true, includeIfNull: false)
  final String originalMimeType;

  @JsonKey(name: r'media_filename', required: true, includeIfNull: false)
  final String mediaFilename;

  @JsonKey(name: r'has_archive_version', required: true, includeIfNull: false)
  final bool hasArchiveVersion;

  @JsonKey(name: r'original_metadata', required: true, includeIfNull: false)
  final Map<String, Object> originalMetadata;

  @JsonKey(name: r'archive_checksum', required: true, includeIfNull: false)
  final String archiveChecksum;

  @JsonKey(
    name: r'archive_media_filename',
    required: true,
    includeIfNull: false,
  )
  final String archiveMediaFilename;

  @JsonKey(name: r'original_filename', required: true, includeIfNull: false)
  final String originalFilename;

  @JsonKey(name: r'archive_size', required: true, includeIfNull: false)
  final int archiveSize;

  @JsonKey(name: r'archive_metadata', required: true, includeIfNull: false)
  final Map<String, Object> archiveMetadata;

  @JsonKey(name: r'lang', required: true, includeIfNull: false)
  final String lang;

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

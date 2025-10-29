//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/compression_enum.dart';
import 'package:paperless_api/generated/lib/src/model/content_enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'bulk_download.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BulkDownload {
  /// Returns a new [BulkDownload] instance.
  BulkDownload({
    this.content = ContentEnum.archive,

    this.compression = CompressionEnum.none,

    this.followFormatting = false,
  });

  @JsonKey(
    defaultValue: ContentEnum.archive,
    name: r'content',
    required: false,
    includeIfNull: false,
  )
  final ContentEnum? content;

  @JsonKey(
    defaultValue: CompressionEnum.none,
    name: r'compression',
    required: false,
    includeIfNull: false,
  )
  final CompressionEnum? compression;

  @JsonKey(
    defaultValue: false,
    name: r'follow_formatting',
    required: false,
    includeIfNull: false,
  )
  final bool? followFormatting;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BulkDownload &&
            runtimeType == other.runtimeType &&
            equals(
              [content, compression, followFormatting],
              [other.content, other.compression, other.followFormatting],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([content, compression, followFormatting]);

  factory BulkDownload.fromJson(Map<String, dynamic> json) =>
      _$BulkDownloadFromJson(json);

  Map<String, dynamic> toJson() => _$BulkDownloadToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

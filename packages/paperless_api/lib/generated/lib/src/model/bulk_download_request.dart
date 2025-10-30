//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/compression_enum.dart';
import 'package:paperless_api/generated/lib/src/model/content_enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'bulk_download_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BulkDownloadRequest {
  /// Returns a new [BulkDownloadRequest] instance.
  BulkDownloadRequest({
    required this.documents,

    this.content = ContentEnum.archive,

    this.compression = CompressionEnum.none,

    this.followFormatting = false,
  });

  @JsonKey(name: r'documents', required: true, includeIfNull: false)
  final List<int> documents;

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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BulkDownloadRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [documents, content, compression, followFormatting],
              [
                other.documents,
                other.content,
                other.compression,
                other.followFormatting,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([documents, content, compression, followFormatting]);

  factory BulkDownloadRequest.fromJson(Map<String, dynamic> json) =>
      _$BulkDownloadRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BulkDownloadRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

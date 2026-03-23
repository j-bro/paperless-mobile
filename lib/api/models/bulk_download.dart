import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/compression_enum.dart';
import 'package:paperless_mobile/api/models/content_enum.dart';

part 'bulk_download.freezed.dart';
part 'bulk_download.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class BulkDownload with _$BulkDownload {
  factory BulkDownload({
    @Default(ContentEnum.archive) ContentEnum? content,
    @Default(CompressionEnum.none) CompressionEnum? compression,
    @Default(false) bool? followFormatting,
  }) = _BulkDownload;

  factory BulkDownload.fromJson(Map<String, dynamic> json) =>
      _$BulkDownloadFromJson(json);
}

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_api/generated/lib/src/model/skip_archive_file_enum.dart';
import 'package:paperless_api/generated/lib/src/model/unpaper_clean_enum.dart';
import 'package:paperless_api/generated/lib/src/model/mode_enum.dart';
import 'package:paperless_api/generated/lib/src/model/output_type_enum.dart';
import 'package:paperless_api/generated/lib/src/model/color_conversion_strategy_enum.dart';
import 'package:dio/dio.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'application_configuration_request.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApplicationConfigurationRequest {
  /// Returns a new [ApplicationConfigurationRequest] instance.
  ApplicationConfigurationRequest({
    required this.userArgs,

    required this.barcodeTagMapping,

    this.outputType,

    this.pages,

    this.language,

    this.mode,

    this.skipArchiveFile,

    this.imageDpi,

    this.unpaperClean,

    this.deskew,

    this.rotatePages,

    this.rotatePagesThreshold,

    this.maxImagePixels,

    this.colorConversionStrategy,

    this.appTitle,

    this.appLogo,

    this.barcodesEnabled,

    this.barcodeEnableTiffSupport,

    this.barcodeString,

    this.barcodeRetainSplitPages,

    this.barcodeEnableAsn,

    this.barcodeAsnPrefix,

    this.barcodeUpscale,

    this.barcodeDpi,

    this.barcodeMaxPages,

    this.barcodeEnableTag,
  });

  @JsonKey(name: r'user_args', required: true, includeIfNull: true)
  final Object? userArgs;

  @JsonKey(name: r'barcode_tag_mapping', required: true, includeIfNull: true)
  final Object? barcodeTagMapping;

  @JsonKey(name: r'output_type', required: false, includeIfNull: false)
  final OutputTypeEnum? outputType;

  // minimum: 1
  // maximum: 2147483647
  @JsonKey(name: r'pages', required: false, includeIfNull: false)
  final int? pages;

  @JsonKey(name: r'language', required: false, includeIfNull: false)
  final String? language;

  @JsonKey(name: r'mode', required: false, includeIfNull: false)
  final ModeEnum? mode;

  @JsonKey(name: r'skip_archive_file', required: false, includeIfNull: false)
  final SkipArchiveFileEnum? skipArchiveFile;

  // minimum: 1
  // maximum: 2147483647
  @JsonKey(name: r'image_dpi', required: false, includeIfNull: false)
  final int? imageDpi;

  @JsonKey(name: r'unpaper_clean', required: false, includeIfNull: false)
  final UnpaperCleanEnum? unpaperClean;

  @JsonKey(name: r'deskew', required: false, includeIfNull: false)
  final bool? deskew;

  @JsonKey(name: r'rotate_pages', required: false, includeIfNull: false)
  final bool? rotatePages;

  // minimum: 0.0
  @JsonKey(
    name: r'rotate_pages_threshold',
    required: false,
    includeIfNull: false,
  )
  final double? rotatePagesThreshold;

  // minimum: 0.0
  @JsonKey(name: r'max_image_pixels', required: false, includeIfNull: false)
  final double? maxImagePixels;

  @JsonKey(
    name: r'color_conversion_strategy',
    required: false,
    includeIfNull: false,
  )
  final ColorConversionStrategyEnum? colorConversionStrategy;

  @JsonKey(name: r'app_title', required: false, includeIfNull: false)
  final String? appTitle;

  @JsonKey(ignore: true)
  final MultipartFile? appLogo;

  @JsonKey(name: r'barcodes_enabled', required: false, includeIfNull: false)
  final bool? barcodesEnabled;

  @JsonKey(
    name: r'barcode_enable_tiff_support',
    required: false,
    includeIfNull: false,
  )
  final bool? barcodeEnableTiffSupport;

  @JsonKey(name: r'barcode_string', required: false, includeIfNull: false)
  final String? barcodeString;

  @JsonKey(
    name: r'barcode_retain_split_pages',
    required: false,
    includeIfNull: false,
  )
  final bool? barcodeRetainSplitPages;

  @JsonKey(name: r'barcode_enable_asn', required: false, includeIfNull: false)
  final bool? barcodeEnableAsn;

  @JsonKey(name: r'barcode_asn_prefix', required: false, includeIfNull: false)
  final String? barcodeAsnPrefix;

  // minimum: 1.0
  @JsonKey(name: r'barcode_upscale', required: false, includeIfNull: false)
  final double? barcodeUpscale;

  // minimum: 1
  // maximum: 2147483647
  @JsonKey(name: r'barcode_dpi', required: false, includeIfNull: false)
  final int? barcodeDpi;

  // minimum: 1
  // maximum: 2147483647
  @JsonKey(name: r'barcode_max_pages', required: false, includeIfNull: false)
  final int? barcodeMaxPages;

  @JsonKey(name: r'barcode_enable_tag', required: false, includeIfNull: false)
  final bool? barcodeEnableTag;

  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ApplicationConfigurationRequest &&
            runtimeType == other.runtimeType &&
            equals(
              [
                userArgs,
                barcodeTagMapping,
                outputType,
                pages,
                language,
                mode,
                skipArchiveFile,
                imageDpi,
                unpaperClean,
                deskew,
                rotatePages,
                rotatePagesThreshold,
                maxImagePixels,
                colorConversionStrategy,
                appTitle,
                appLogo,
                barcodesEnabled,
                barcodeEnableTiffSupport,
                barcodeString,
                barcodeRetainSplitPages,
                barcodeEnableAsn,
                barcodeAsnPrefix,
                barcodeUpscale,
                barcodeDpi,
                barcodeMaxPages,
                barcodeEnableTag,
              ],
              [
                other.userArgs,
                other.barcodeTagMapping,
                other.outputType,
                other.pages,
                other.language,
                other.mode,
                other.skipArchiveFile,
                other.imageDpi,
                other.unpaperClean,
                other.deskew,
                other.rotatePages,
                other.rotatePagesThreshold,
                other.maxImagePixels,
                other.colorConversionStrategy,
                other.appTitle,
                other.appLogo,
                other.barcodesEnabled,
                other.barcodeEnableTiffSupport,
                other.barcodeString,
                other.barcodeRetainSplitPages,
                other.barcodeEnableAsn,
                other.barcodeAsnPrefix,
                other.barcodeUpscale,
                other.barcodeDpi,
                other.barcodeMaxPages,
                other.barcodeEnableTag,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        userArgs,
        barcodeTagMapping,
        outputType,
        pages,
        language,
        mode,
        skipArchiveFile,
        imageDpi,
        unpaperClean,
        deskew,
        rotatePages,
        rotatePagesThreshold,
        maxImagePixels,
        colorConversionStrategy,
        appTitle,
        appLogo,
        barcodesEnabled,
        barcodeEnableTiffSupport,
        barcodeString,
        barcodeRetainSplitPages,
        barcodeEnableAsn,
        barcodeAsnPrefix,
        barcodeUpscale,
        barcodeDpi,
        barcodeMaxPages,
        barcodeEnableTag,
      ]);

  factory ApplicationConfigurationRequest.fromJson(Map<String, dynamic> json) =>
      _$ApplicationConfigurationRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ApplicationConfigurationRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

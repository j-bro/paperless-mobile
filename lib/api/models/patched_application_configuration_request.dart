import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/color_conversion_strategy_enum.dart';
import 'package:paperless_mobile/api/models/mode_enum.dart';
import 'package:paperless_mobile/api/models/output_type_enum.dart';
import 'package:paperless_mobile/api/models/skip_archive_file_enum.dart';
import 'package:paperless_mobile/api/models/unpaper_clean_enum.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_application_configuration_request.g.dart';

@JsonSerializable(
  createFactory: false,
  createToJson: true,
  includeIfNull: false,
)
class PatchedApplicationConfigurationRequest {
  final PatchedValue<Object?>? userArgs;
  final PatchedValue<Object?>? barcodeTagMapping;
  final PatchedValue<OutputTypeEnum?>? outputType;

  // minimum: 1
  // maximum: 2147483647
  final PatchedValue<int?>? pages;
  final PatchedValue<String?>? language;
  final PatchedValue<ModeEnum?>? mode;
  final PatchedValue<SkipArchiveFileEnum?>? skipArchiveFile;

  // minimum: 1
  // maximum: 2147483647
  final PatchedValue<int?>? imageDpi;
  final PatchedValue<UnpaperCleanEnum?>? unpaperClean;
  final PatchedValue<bool?>? deskew;
  final PatchedValue<bool?>? rotatePages;

  // minimum: 0.0
  final PatchedValue<double?>? rotatePagesThreshold;

  // minimum: 0.0
  final PatchedValue<double?>? maxImagePixels;
  final PatchedValue<ColorConversionStrategyEnum?>? colorConversionStrategy;
  final PatchedValue<String?>? appTitle;

  // @JsonKey(includeToJson: false)
  // PatchedValue<MultipartFile?>? appLogo,
  final PatchedValue<bool?>? barcodesEnabled;
  final PatchedValue<bool?>? barcodeEnableTiffSupport;
  final PatchedValue<String?>? barcodeString;
  final PatchedValue<bool?>? barcodeRetainSplitPages;
  final PatchedValue<bool?>? barcodeEnableAsn;
  final PatchedValue<String?>? barcodeAsnPrefix;

  // minimum: 1.0
  final PatchedValue<double?>? barcodeUpscale;

  // minimum: 1
  // maximum: 2147483647
  final PatchedValue<int?>? barcodeDpi;

  // minimum: 1
  // maximum: 2147483647
  final PatchedValue<int?>? barcodeMaxPages;
  final PatchedValue<bool?>? barcodeEnableTag;

  PatchedApplicationConfigurationRequest({
    this.userArgs,
    this.barcodeTagMapping,
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

  Map<String, dynamic> toJson() => processPatchedValueJson(
    _$PatchedApplicationConfigurationRequestToJson(this),
  );
}

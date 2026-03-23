import 'package:paperless_mobile/api/utils/request_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'paperless_server_information_model.freezed.dart';

@freezed
abstract class PaperlessServerInformationModel
    with _$PaperlessServerInformationModel {
  static const String versionHeader = 'x-version';
  static const String apiVersionHeader = 'x-api-version';

  const PaperlessServerInformationModel._();
  factory PaperlessServerInformationModel({
    required String version,
    required int apiVersion,
    required bool isUpdateAvailable,
    required String latestVersion,
  }) = _PaperlessServerInformationModel;

  int compareToOtherVersion(String other) {
    return getExtendedVersionNumber(
      version,
    ).compareTo(getExtendedVersionNumber(other));
  }
}

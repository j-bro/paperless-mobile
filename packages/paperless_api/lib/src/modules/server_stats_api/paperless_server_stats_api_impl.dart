import 'package:dio/dio.dart';
import 'package:paperless_api/generated/lib/src/model/ui_settings_view.dart';
import 'package:paperless_api/src/extensions/dio_exception_extension.dart';
import 'package:paperless_api/src/models/paperless_api_exception.dart';
import 'package:paperless_api/src/models/paperless_server_information_model.dart';
import 'package:paperless_api/src/models/paperless_server_statistics_model.dart';
import 'package:paperless_api/src/request_utils.dart';

import 'paperless_server_stats_api.dart';

///
/// API for retrieving information about paperless server state,
/// such as version number, and statistics including documents in
/// inbox and total number of documents.
///
class PaperlessServerStatsApiImpl implements PaperlessServerStatsApi {
  final Dio client;
  static const _fallbackVersion = '0.0.0';
  PaperlessServerStatsApiImpl(this.client);

  @override
  Future<PaperlessServerInformationModel> getServerInformation() async {
    try {
      final response = await client.get(
        "/api/remote_version/",
        options: Options(validateStatus: (status) => status == 200),
      );
      final latestVersion = response.data["version"] as String;
      final version =
          response.headers.value(
            PaperlessServerInformationModel.versionHeader,
          ) ??
          _fallbackVersion;
      final updateAvailable = response.data["update_available"] as bool;
      return PaperlessServerInformationModel(
        apiVersion: int.parse(
          response.headers.value(
            PaperlessServerInformationModel.apiVersionHeader,
          )!,
        ),
        latestVersion: latestVersion,
        version: version,
        isUpdateAvailable: updateAvailable,
      );
    } on DioException catch (exception) {
      throw exception.unravel(
        orElse: const PaperlessApiException(
          ErrorCode.serverInformationLoadFailed,
        ),
      );
    }
  }

  @override
  Future<PaperlessServerStatisticsModel> getServerStatistics() async {
    final result = await getSingleResult(
      '/api/statistics',
      PaperlessServerStatisticsModel.fromJson,
      ErrorCode.serverStatisticsLoadFailed,
      client: client,
    );
    if (result == null) {
      throw const PaperlessApiException(ErrorCode.serverStatisticsLoadFailed);
    }
    return result;
  }

  @override
  Future<UiSettingsView> getUiSettings() async {
    final result = await getSingleResult(
      '/api/ui_settings/',
      UiSettingsView.fromJson,
      ErrorCode.uiSettingsLoadFailed,
      client: client,
    );
    if (result == null) {
      throw const PaperlessApiException(ErrorCode.uiSettingsLoadFailed);
    }
    return result;
  }
}

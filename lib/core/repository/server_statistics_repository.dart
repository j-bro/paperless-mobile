import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';

class ServerStatisticsRepository {
  final PaperlessServerStatsApi _api;

  ServerStatisticsRepository(this._api);
  Query<PaperlessServerInformationModel> get serverInformationQuery {
    return Query(
      key: 'server_information',
      queryFn: () async {
        try {
          return await _api.getServerInformation();
        } catch (error, stackTrace) {
          logger.fe(
            'An error occurred trying to get the server information',
            className: runtimeType.toString(),
            methodName: 'getServerInformationQuery',
            error: error,
            stackTrace: stackTrace,
          );
          rethrow;
        }
      },
    );
  }

  Query<PaperlessServerStatisticsModel> get serverStatisticsQuery {
    return Query(
      key: 'server_statistics',
      queryFn: () async {
        try {
          return await _api.getServerStatistics();
        } catch (error, stackTrace) {
          logger.fe(
            'An error occurred trying to get server statistics',
            className: runtimeType.toString(),
            methodName: 'getServerStatisticsQuery',
            error: error,
            stackTrace: stackTrace,
          );
          rethrow;
        }
      },
    );
  }
}

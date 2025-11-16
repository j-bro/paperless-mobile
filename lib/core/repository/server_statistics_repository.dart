import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:paperless_api/paperless_api.dart';

class ServerStatisticsRepository {
  final PaperlessServerStatsApi _api;

  ServerStatisticsRepository(this._api);
  Query<PaperlessServerInformationModel> getServerInformationQuery() {
    return Query(
      key: const ['server_statistics'],
      queryFn: () async {
        return _api.getServerInformation();
      },
    );
  }

  Query<PaperlessServerStatisticsModel> getServerStatisticsQuery() {
    return Query(
      key: const ['server_statistics_data'],
      queryFn: () async {
        return _api.getServerStatistics();
      },
    );
  }
}

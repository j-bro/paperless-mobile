import 'package:dio/dio.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';

class OidcApi {
  final Dio _dio;
  OidcApi(this._dio);

  Future<List<OidcProvider>> fetchProviders(String serverUrl) async {
    try {
      final res = await _dio.get(
        '$serverUrl/api/profile/social_account_providers/',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );
      if (res.statusCode == 404) return [];
      final data = res.data;
      final list = data is List ? data : (data is Map ? (data['results'] ?? data['providers'] ?? []) : []);
      if (list is! List) return [];
      return list.whereType<Map>().map((e) => OidcProvider.fromJson(Map<String, dynamic>.from(e))).toList();
    } on DioException {
      return [];
    }
  }
}

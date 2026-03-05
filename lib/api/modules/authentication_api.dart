import 'package:dio/dio.dart';
import 'package:paperless_mobile/api/paperless_api.dart';

abstract class PaperlessAuthenticationApi {
  Future<String> token(PaperlessAuthTokenRequest request);
  String getOAuthCallback();
}

class PaperlessAuthenticationApiImpl implements PaperlessAuthenticationApi {
  final Dio client;

  PaperlessAuthenticationApiImpl(this.client);

  @override
  Future<String> token(PaperlessAuthTokenRequest request) async {
    try {
      final response = await client.post(
        "/api/token/",
        data: request.toJson(),
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          followRedirects: false,
          headers: {"Accept": "application/json"},
        ),
      );
      return PaperlessAuthToken.fromJson(response.data).token;
    } on DioException catch (exception) {
      throw exception.unravel();
    } catch (error, stackTrace) {
      throw PaperlessApiException.unknown(
        details: error.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  String getOAuthCallback() {
    return "${client.options.baseUrl}/oauth/callback/";
  }
}

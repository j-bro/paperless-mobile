import 'package:dio/dio.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_api/src/extensions/dio_exception_extension.dart';

class PaperlessAuthenticationApiImpl implements PaperlessAuthenticationApi {
  final Dio client;

  PaperlessAuthenticationApiImpl(this.client);

  @override
  Future<String> login({
    required String username,
    required String password,
    String? code,
  }) async {
    try {
      final response = await client.post(
        "/api/token/",
        data: {"username": username, "password": password, "code": code},
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          followRedirects: false,
          headers: {"Accept": "application/json"},
        ),
      );
      return response.data['token'];
    } on DioException catch (exception) {
      throw exception.unravel();
    } catch (error, stackTrace) {
      throw PaperlessApiException.unknown(
        details: error.toString(),
        stackTrace: stackTrace,
      );
    }
  }
}

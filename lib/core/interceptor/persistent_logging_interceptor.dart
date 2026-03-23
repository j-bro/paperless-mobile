import 'package:dio/dio.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';

class PersistentLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.ft(
      options.uri.path,
      className: 'HTTPRequest',
      methodName: options.method,
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.ft(
      '${response.requestOptions.uri.path} - ${response.statusCode}',
      className: 'HTTPResponse',
      methodName: response.requestOptions.method,
    );
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.fe(
      '${err.requestOptions.uri.path} - ${err.response?.statusCode}',
      className: 'HTTPError',
      methodName: err.requestOptions.method,
      error: err.error,
    );
    handler.next(err);
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/api/modules/oidc_api.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/model/reachability_status.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';
import 'package:paperless_mobile/features/login/server_connection/model/header_entry.dart';

part 'server_connection_state.dart';

class ServerConnectionCubit extends Cubit<ServerConnectionState> {
  final ConnectivityStatusService _connectivityStatusService;
  ServerConnectionCubit(this._connectivityStatusService)
    : super(const ServerConnectionInitial());

  void reset() {
    emit(const ServerConnectionInitial());
  }

  void checkReachability({
    required String address,
    ClientCertificate? clientCertificate,
    List<HeaderEntry>? additionalHeaders,
  }) async {
    emit(ServerConnectionCheckingReachability(address: address));
    try {
      final status = await _connectivityStatusService
          .isPaperlessServerReachable(
            address,
            clientCertificate,
            additionalHeaders,
          );
      if (status == ReachabilityStatus.reachable) {
        // Best-effort OIDC provider discovery: older servers without the
        // providers endpoint yield [] and the login UI stays unchanged.
        List<OidcProvider> providers = const [];
        try {
          // Fresh server-scoped Dio: never mutate the shared SessionManager
          // client's baseUrl (or inherit its offline/retry interceptor
          // stack, which can stall unauthenticated discovery) for
          // best-effort provider fetching.
          final oidcApi = OidcApi(
            Dio(
              BaseOptions(
                baseUrl: address,
                connectTimeout: const Duration(seconds: 5),
                receiveTimeout: const Duration(seconds: 5),
              ),
            ),
          );
          providers = await oidcApi.fetchProviders(address);
        } catch (error, stackTrace) {
          logger.fw(
            'OIDC provider discovery failed, continuing without SSO',
            className: runtimeType.toString(),
            methodName: 'checkReachability',
            error: error,
            stackTrace: stackTrace,
          );
        }
        emit(
          ServerConnectionSuccess(
            serverUrl: address,
            clientCertificate: clientCertificate,
            additionalHeaders: additionalHeaders,
            oidcProviders: providers,
          ),
        );
      } else {
        logger.fw(
          'Server is not reachable',
          className: runtimeType.toString(),
          methodName: 'checkReachability',
          error: {'status': status.toString()},
        );
        emit(ServerConnectionUnreachable(address: address, status: status));
      }
    } catch (error, stackTrace) {
      logger.fe(
        'Error while checking server reachability',
        className: runtimeType.toString(),
        methodName: 'checkReachability',
        error: error,
        stackTrace: stackTrace,
      );
      emit(ServerConnectionInitial());
    }
  }
}

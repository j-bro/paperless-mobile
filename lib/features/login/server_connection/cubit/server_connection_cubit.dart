import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/model/reachability_status.dart';
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
    final status = await _connectivityStatusService.isPaperlessServerReachable(
      address,
      clientCertificate,
      additionalHeaders,
    );

    if (status == ReachabilityStatus.reachable) {
      emit(
        ServerConnectionSuccess(
          serverUrl: address,
          clientCertificate: clientCertificate,
          additionalHeaders: additionalHeaders,
        ),
      );
    } else {
      emit(ServerConnectionUnreachable(address: address, status: status));
    }
  }
}

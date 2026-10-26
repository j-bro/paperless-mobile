part of 'server_connection_cubit.dart';

sealed class ServerConnectionState {
  const ServerConnectionState();
}

class ServerConnectionInitial extends ServerConnectionState {
  const ServerConnectionInitial();
}

class ServerConnectionCheckingReachability extends ServerConnectionState {
  final String address;
  const ServerConnectionCheckingReachability({required this.address});
}

class ServerConnectionSuccess extends ServerConnectionState {
  final String serverUrl;
  final ClientCertificate? clientCertificate;
  final List<HeaderEntry>? additionalHeaders;
  final OidcCapability oidcCapability;
  List<OidcProvider> get oidcProviders => oidcCapability.providers;
  const ServerConnectionSuccess({
    required this.serverUrl,
    this.clientCertificate,
    this.additionalHeaders,
    this.oidcCapability = const OidcCapability(flow: OidcFlow.none),
  });

  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null || a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerConnectionSuccess &&
          runtimeType == other.runtimeType &&
          serverUrl == other.serverUrl &&
          clientCertificate == other.clientCertificate &&
          _listEquals(additionalHeaders, other.additionalHeaders) &&
          oidcCapability == other.oidcCapability;

  @override
  int get hashCode => Object.hash(
        serverUrl,
        clientCertificate,
        additionalHeaders == null
            ? null
            : Object.hashAll(additionalHeaders!),
        oidcCapability,
      );
}

class ServerConnectionUnreachable extends ServerConnectionState {
  final String address;
  final ReachabilityStatus status;

  const ServerConnectionUnreachable({
    required this.address,
    required this.status,
  });
}

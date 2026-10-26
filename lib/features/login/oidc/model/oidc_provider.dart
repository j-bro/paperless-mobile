class OidcProvider {
  final String id;
  final String name;
  final String? discoveryUrl;
  final String? clientId;
  const OidcProvider({required this.id, required this.name, this.discoveryUrl, this.clientId});

  factory OidcProvider.fromJson(Map<String, dynamic> json) {
    return OidcProvider(
      id: json['id'] as String? ?? json['provider_id'] as String? ?? '',
      name: json['name'] as String? ?? json['provider'] as String? ?? '',
      discoveryUrl: json['discovery_url'] as String? ?? json['server_url'] as String?,
      clientId: json['client_id'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OidcProvider &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          discoveryUrl == other.discoveryUrl &&
          clientId == other.clientId;

  @override
  int get hashCode => Object.hash(id, name, discoveryUrl, clientId);
}

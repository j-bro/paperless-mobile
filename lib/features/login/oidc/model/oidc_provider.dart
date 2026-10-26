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
}

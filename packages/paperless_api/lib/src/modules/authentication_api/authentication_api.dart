abstract class PaperlessAuthenticationApi {
  ///
  /// Returns an authentication token.
  ///
  Future<String> login({
    required String username,
    required String password,
    String? code,
  });
}

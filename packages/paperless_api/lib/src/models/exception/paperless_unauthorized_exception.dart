class PaperlessUnauthorizedException implements Exception {
  final String? message;

  PaperlessUnauthorizedException(this.message);

  @override
  String toString() => 'PaperlessUnauthorizedException: $message';
}

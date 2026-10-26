sealed class OidcState { const OidcState(); }
class OidcInitial extends OidcState { const OidcInitial(); }
class OidcExchanging extends OidcState { const OidcExchanging(); }
class OidcCancelled extends OidcState { const OidcCancelled(); }
class OidcOtpRequired extends OidcState {
  final String sessionToken;
  const OidcOtpRequired(this.sessionToken);
}
class OidcSuccess extends OidcState {
  final String drfToken;
  const OidcSuccess(this.drfToken);
}
class OidcError extends OidcState {
  final String message;
  const OidcError(this.message);
}

# OIDC Auth Support — Design

Date: 2026-10-26
Status: Draft for review
Scope: paperless-mobile (Flutter) login via paperless-ngx OIDC / allauth headless, Swift-Paperless-style native flow. Manual API-key remains as fallback.

## 1. Background

Current login (`lib/features/login/authenticate_user/cubit/authenticate_user_cubit.dart`):
- `PasswordAuthenticationCredentials` → `POST /api/token/` → DRF token.
- `ApiKeyAuthenticationCredentials` → `HEAD /api/profile/` validation.
- Token stored in `UserCredentials.token`, sent as `Authorization: Token <token>` by `SessionManagerImpl`.

This breaks when server has `PAPERLESS_DISABLE_REGULAR_LOGIN=true` + SSO-only, or users authenticate via OIDC IdP. Workaround today is copy-paste API key from web UI.

Server side (paperless-ngx ≥ ~v3.0, PR #11756):
- `django-allauth headless` exposed under `/api/auth/` with custom `DrfTokenStrategy` returning familiar DRF token in `meta.access_token`.
- `GET /api/profile/social_account_providers/` lists configured OIDC providers.
- Rejected: custom `/api/auth/external-login/*` redirect flow (PR #12132, closed Apr 2026). Do not depend on it.

Reference implementation: Swift Paperless `/oidc/` docs — PKCE public-client flow with `x-paperless://oidc-callback`, TOTP second step.

## 2. Goals / Non-goals

Goals:
- "Continue with SSO" button when server advertises OIDC providers.
- System-browser PKCE flow, deep-link back, exchange provider token via allauth headless for DRF token.
- Support TOTP-after-OIDC (6-digit + 8-digit recovery), multi-account, biometric, `restoreSession` unchanged.
- SSO-only servers (regular login disabled) usable. Old servers without OIDC unchanged.
- Keep manual API-key entry as fallback for secret-required IdPs (Google/MS/GitHub).

Non-goals:
- No custom server endpoints, no Login Flow v2 poll tokens.
- No embedded WebView scraping.
- No token refresh / logout at IdP (DRF tokens are long-lived; out of scope).
- No management of social-account linking / disconnect in-app v1.

## 3. Architecture Overview

```
App → GET /api/profile/social_account_providers/ → provider list
App → GET /_allauth/app/v1/... config → client_id + discovery URL
App → system browser (AppAuth) → IdP authorize (PKCE S256, public client)
IdP → custom-scheme redirect → App (code + state)
App → IdP token endpoint (code_verifier, no secret) → id_token/access_token
App → POST allauth provider_token (X-Session-Token) → meta.access_token (DRF token)
App → existing AuthenticationCubit.addUser(serverUrl, token, ...) → profile, store, session
```

Downstream (`SessionManager`, `UserCredentials`, interceptors, `AuthenticationCubit`) unchanged — they keep consuming DRF `Token`.

## 4. Components

### 4.1 Server capability detection
- Where: extend `ConnectivityStatusService` / `ServerConnectionCubit` success path, or new `OidcAvailabilityService`.
- What: after reachability check, `GET /api/profile/social_account_providers/` (auth-free? verify; fallback to allauth provider endpoint). Cache per `serverUrl`.
- Output: `{ hasOidc: bool, providers: [{id, name, ...}], regularLoginDisabled: bool? }`.
- If request 404/old server → `hasOidc=false`, current UI unchanged.

### 4.2 OIDC client
- New package dep: `flutter_appauth` (preferred: handles PKCE, Custom Tabs / ASWebAuthenticationSession, secure browser) + `app_links` for deep-link capture. Alternative evaluated: `openid_client + flutter_web_auth_2` — more manual.
- New `lib/features/login/oidc/` module:
  - `oidc_provider_model.dart` (id, name, discoveryUrl, clientId from server)
  - `oidc_authentication_api.dart` (allauth headless: session-token handling, `provider_token` exchange, `mfa_authenticate`)
  - `oidc_cubit.dart` states: Initial / Discovering / BrowserOpen / Exchanging / OtpRequired / Success / Error(+Cancelled)
- PKCE S256 generated per attempt, `state` validated, `code_verifier` never leaves device except to IdP token endpoint.

### 4.3 Platform wiring
- Custom scheme e.g. `paperlessmobile://oidc-callback` (distinct from Swift's `x-paperless://` to allow both apps installed; confirm no collision requirement with IdP docs).
- Android (`android/app/src/main/AndroidManifest.xml`, `MainActivity singleTop`): new `<intent-filter>` VIEW+BROWSABLE with `<data android:scheme="paperlessmobile" android:host="oidc-callback"/>`.
- iOS (`ios/Runner/Info.plist`, `CFBundleURLTypes` currently only `ShareMedia`): add `paperlessmobile` scheme.
- IdP admin must register both `https://<server>/accounts/oidc/<provider>/login/callback/` and mobile scheme. Document in-app help + README.

### 4.4 UI flow
- `ServerConnectionPage` → `AuthenticateUserPage`:
  - `hasOidc==false`: current username/password + API-key UI.
  - `hasOidc==true, regularLogin enabled`: show "Continue with SSO" primary button above/below existing form + provider picker if >1.
  - `regularLogin disabled`: hide password form, show SSO-only + API-key fallback link.
- New `OidcButton + OidcProviderSheet + OidcLoading/Error` widgets. Reuse `OtpInputPage` pattern for TOTP-after-OIDC.
- Strings via `intl*.arb`, help link to docs for IdP whitelist setup.

### 4.5 Credential model
- Option: add `AuthenticationCredentials.oidc({providerId, idToken/accessToken})` OR keep separate cubit passing final DRF token directly to `AddUserRouteExtra(token: ...)`. Preferred: separate cubit → final token → existing `addUser()` to minimize changes to password/apiKey validation logic in `AuthenticationCredentialsFormField`.
- `UserCredentials` unchanged. Dead `PaperlessAuthenticationApi.getOAuthCallback()` (`/oauth/callback/`) removed.

### 4.6 Error handling
- User cancel browser → `Cancelled`, stay on login.
- Invalid state, PKCE mismatch, expired code → retryable error with logs redacted.
- Allauth `410 Gone` → restart session cleanly. `401 meta.is_authenticated` → re-auth path.
- `provider_signup` (unlinked) → show "link in web UI first" message v1 (no auto-signup unless server allows).
- Network / discovery failures → fallback hint to API-key.

## 5. Data flow / Session tokens (allauth app mode)

- No cookies. Use `X-Session-Token` header: absent on first call, then persist `meta.session_token` from responses on all subsequent calls.
- Success response contains `meta.access_token` = DRF token → proceed to `GET /api/profile/` + `getUiSettings()` as today for `localUserId = username@serverUrl`.
- TOTP: `mfa_authenticate` flow with code → same session token → final access token.

## 6. Security considerations

- System browser only (no embedded WebView) for IdP credentials isolation.
- Public client, no secret bundled. PKCE S256 mandatory.
- Custom-scheme redirect validated by `state`; use `https` app-link if stronger guarantee needed later (out of scope v1).
- Tokens in `flutter_secure_storage` via existing `EncryptedLocalStore`; never log tokens (`redactUserId`/redaction utils).
- `badCertificateCallback=true` in `SessionManagerImpl` is pre-existing risk; OIDC browser flow uses OS TLS validation, unaffected.

## 7. Testing strategy

- Unit: PKCE/state, provider parsing, allauth session-token handling (mock Dio), `OidcCubit` state machine incl. cancel/410/401/TOTP.
- Widget: SSO button visibility matrix (no OIDC / OIDC+password / SSO-only), provider sheet, OTP-after-OIDC.
- Manual IdP matrix: Authentik, Authelia, PocketID (public+PKCE), Keycloak. Negative: secret-required provider shows documented error.
- Regression: old server (no provider endpoint) → old UI; password + API-key flows unchanged; multi-account switch/restore.
- Integration: mock allauth headless + IdP stub if feasible; else manual checklist.

## 8. Rollout / Docs

- Feature-gated by server capability, no remote flag needed.
- Update README + in-app help: IdP requirements (true OIDC, discovery, public-client PKCE, link identities), callback URL registration steps, "if your IdP needs a secret use API-key instead".
- Version note: requires paperless-ngx with #11756; document minimum server version after verification against live server.

## 9. Open questions (to resolve in plan)

1. Exact allauth headless paths mounted by paperless-ngx (`/_allauth/app/v1/...` vs `/api/auth/...`) and provider-list shape — verify against live server + `docs.allauth.org headless` spec.
2. Where does mobile `client_id` come from — server-provided per-provider or single shared public client? Confirm with server response.
3. Final custom scheme name (`paperlessmobile://oidc-callback` vs reuse `x-paperless://` pattern).
4. `GET /api/profile/social_account_providers/` auth requirements (does it need auth? If yes, call unauthenticated and handle 403).
5. `PAPERLESS_DISABLE_REGULAR_LOGIN` detectability from client (header/endpoint or infer from 403 on `/api/token/`?).

## 10. Alternatives considered

- B manual API-key only — kept as fallback, rejected as primary (poor UX).
- C embedded WebView scrape — rejected (insecure, fragile).
- Nextcloud-style poll-token / custom external-login endpoints — rejected (upstream paperless-ngx declined to maintain; stick to allauth headless).

---

## Spec self-review

- Placeholders: none — open questions explicitly listed in §9 for plan phase.
- Consistency: downstream unchanged (§3 last para) matches §4.5; fallback B retained in goals and §10.
- Scope: single implementation plan (OIDC login v1, no linking management, no logout-at-IdP).
- Ambiguity: scheme name and exact allauth paths flagged as TBD pending live-server verification, not assumed.

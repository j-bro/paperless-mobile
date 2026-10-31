# Native SSO (system-browser direct flow) — debugging record

Goal: log in via the system browser (AppAuth PKCE, no secrets in the app)
against paperless-ngx v3 + authentik, instead of the in-app WebView fallback.

**Status (2026-10-29):** redirect reaches the phone with a valid `code`+`state`
(proven by relay logs), but the AppAuth chain resolves it as
cancel-without-data (`null_intent`) ~1s after tap. WebView fallback login
works on the same phone. All other reported bugs on this branch are fixed
(public share wiring, saved-views null flags, log-parser crash,
Continue-button spinner — the spinner was already present).

Conventions below: `paperless.example.com` = paperless server,
`idp.example.com` = authentik IdP. Server is paperless-ngx v3 (latest),
IdP is authentik with an OIDC provider for paperless. Test device uses
Firefox (95 tabs) as default browser; Chrome behaves the same (see §5).

## 1. Verified facts (probed, not guessed)

- Headless auth needs **no server config**: upstream mounts allauth
  headless unconditionally at `/api/auth/headless/` (verified in
  `src/paperless/urls.py`). Live probe of
  `/api/auth/headless/app/v1/config` returns providers with `client_id` +
  `openid_configuration_url` + `provider_token` flow. The app previously
  probed `/_allauth/...` paths that don't exist on paperless — fixed in
  `lib/api/modules/oidc_api.dart` (paperless mount first, legacy fallback).
- `redirect_uri` (`paperlessmobile://oidc-callback`) **is registered** at
  the IdP: unauthenticated authorize requests 302 to the login flow
  instead of erroring (probed).
- IdP chain healthy from outside: authorize → 302 (0.09s) → login flow
  page 200 + valid HTML; discovery doc valid; TLS chain valid, hostname
  covered. Both hosts resolve to the same internal IP that the app's
  working API calls already reach.
- Intent resolution works: the OS offers "Open in Paperless Mobile app?"
  for the callback URL (observed on-device).
- The APK's merged manifest was inspected per build (`aapt dump
  xmltree`): receiver/relay declarations verified in the shipped binary,
  including the duplicate-filter bug (§3.4) before it shipped again.

## 2. Attempt timeline (build → symptom → evidence → verdict)

- **B0 (`new-features` APK): filter on MainActivity.** Redirect bounced
  to the app's start screen, flow stuck. Verdict: MainActivity received
  the redirect but AppAuth was never wired to it — result undeliverable.
- **B1 (receiver-only declaration):** blank browser tab, no return.
  Verdict: redirect went to the transparent receiver with nothing
  pending/visible; task emptied back to the browser.
- **B2 (+ tapping/cancel/startup logging):** logs showed tap → browser →
  *nothing* (user had quit to export logs), then tap → close → clean
  `cancelled by user`. Verdict: instrumentation works; cancel path honest.
- **B3 (relay launching MainActivity with CLEAR_TOP):** `null_intent`
  ~130ms after every redirect *that carried code+state* (relay log proves
  receipt). Verdict: **self-inflicted** — CLEAR_TOP finished the
  still-working AuthorizationManagementActivity; cancel beat response.
- **B4 (`isTaskRoot` gate):** same nulls. Verdict: gate never engaged —
  empty `taskAffinity` never joins empty `taskAffinity`, so the relay sat
  alone and was trivially root on every receipt.
- **B5 (same-task affinity):** same nulls. Verdict: superseded before it
  could matter — see §4.
- **B6 (current): relay observes + forwards only; MainActivity foregrounded
  with REORDER_TO_FRONT (no finishing anything).** Pending device test.

## 3. Mechanisms established (from shipped sources, not memory)

- `flutter_appauth` 7.0.1 Android completes via
  `MainActivity.startActivityForResult(MANAGEMENT, RC_AUTH_EXCHANGE_CODE)`
  (`FlutterAppauthPlugin.java:355-356`).
- `null_intent` = `onActivityResult` with a **null intent** (same file,
  `NULL_INTENT_ERROR_CODE`). AppAuth-Android documents exactly when that
  happens: *"If the user presses the back button or closes the browser
  tab, the launched activity will call setResult with RESULT_CANCELED
  **without a data Intent**"* (`AuthorizationService.java:407-411`).
- Browser selection is AppAuth's own: `BrowserSelector.select` returns the
  **first Custom-Tab-capable match** (`BrowserSelector.java:152`) — the
  user's default-browser setting is irrelevant. "Powered by Firefox" UI in
  screenshots proves Firefox is selected on the test phone, so a "Chrome
  test" that doesn't disable Firefox likely still exercises Firefox.
- A received `code` is useless without the in-memory PKCE verifier (held
  inside the plugin call stack). Any path that clears the pending
  operation first (cancel, error, process death) orphans the code
  permanently. There is no resume-the-code path; only retry or fallback.

## 4. Ruled out (with evidence)

- Server missing headless → fixed paths, live-verified JSON.
- `redirect_uri` unregistered → disproven (redirects fire).
- Broken IdP / TLS / DNS → probed healthy; same IP:port serves working API.
- Firefox-vs-Chrome engine difference → same symptom both.
- Missing receiver declaration → binary-verified present (twice, see below).
- Duplicate intent filters (library receiver + relay both claimed the
  scheme) → found via `aapt`, fixed by stripping the library filter.
- User back-press as the 1.4s nulls → timing + prompt evidence point at
  automatic tab teardown on external navigation instead.
- "Don't keep activities" → never confirmed; process demonstrably alive
  (continuous Dart logs across attempts).

## 5. Open questions

1. Does the current build (observe-only relay + REORDER_TO_FRONT) complete
   a live pass? Predicted yes; pending device run.
2. Which browser does AppAuth actually launch if Firefox is disabled?
   (Validates §3 selection claim; also the fastest workaround if needed.)
3. If nulls persist with zero app-side finishing: `adb logcat` during the
   tap (ActivityManager START lines + AppAuth tags) and
   `adb shell dumpsys activity activities` for task contents.

## Unrelated finding (same night): reachability vs slow schema endpoint

Symptom: "Could not establish a connection" while the web UI looked
fine. Server-side (traefik access logs): `/` → 302 and
`/accounts/login/` → 200 instantly, but **every** `/api/schema/` hit died
at exactly the client's timeout (5.0s app, 10s/15s curl) with the backend
never answering — while `/api/statistics/` answered 401 in 0.4s. So the
server was up with a working API layer; only drf-spectacular schema
generation wedged (post-v3-upgrade behavior). The app exclusively trusted
`HEAD /api/schema/`, hence the false unreachable.

Fix (`connectivity_status_service.dart`): on a failed schema probe that
smells like slowness, confirm liveness with cheap `GET /api/statistics/`
(any HTTP answer, incl. 401/403, counts as reachable). Subtlety that bit
once: `ServerReachabilityErrorInterceptor` rewrites all errors to type
`unknown` with a mapped `ReachabilityStatus` payload, so the gate must
match mapped `connectionTimeout`/`notReachable` — not just raw Dio
timeout types. DNS/TLS errors still fail fast. Covered by
`test/core/service/connectivity_status_service_test.dart` (hanging-schema
fake server + refused-connection cases).

Deliberately NOT done: raising the 5s schema timeout. Schema generation
observably exceeds 15s when wedged, while statistics answers in <1s, so
waiting longer only delays dead-server detection for zero gain.

## ADB findings: split tasks, then the hanging Management

With the phone on ADB, `dumpsys activity activities` showed the live
stack at receipt time: one task held Management + the Firefox tab + a
**second** MainActivity, while the original MainActivity (holding the
pending Dart future) waited in another task. Cause: the relay's
MainActivity relaunch — any flags — risks a second instance/second task,
so response and waiter never meet. The relay now launches nothing:
record + forward + finish, letting the VIEW intent and the
response-handling CLEAR_TOP do all task movement.

Remaining hypothesis if hangs persist: Management itself dead at
response time (fresh stateless instance → silent finish, no result).
ADB discriminators: `dumpsys` task contents at hang time + AppAuth's own
`W/AppAuth` logcat lines (`No stored state` proves it).

## Final relay design + outcome notifications (current)

Live `dumpsys` + `am start` probes proved the response must reach the
*tap-time* Management instance in the package-affinity task; anything
else spawns a stateless instance that silently drops it. So the relay
does exactly three things — record, forward (NEW_TASK, joining
Management's task), finish — and launches/finishes nothing else: every
MainActivity-launch variant tried (CLEAR_TOP, REORDER, plain) either
murdered Management or forked a duplicate MainActivity into a second
task. Since outcomes can now complete while the app task stays
backgrounded, the SSO button also posts system notifications on success,
failure, and second-factor-required (no-op in tests where the service is
absent), so an invisible completion still brings the user back.

## Single shared task (current)

ADB `dumpsys` showed the price of split tasks live: one task holding
Management + browser tab + a *second* MainActivity while the original
(with the pending Dart future) waited in another task — response and
waiter never meeting. Root: `MainActivity` used the Flutter template's
empty `taskAffinity`, which provably never merges (three separate
observations), while AppAuth's `singleTask` activities default to package
affinity. Fix: dropped all empty affinities (MainActivity, relay;
Management keeps library defaults), so the entire auth chain shares ONE
task as AppAuth's back-stack design assumes. Verified in the merged
manifest (zero `taskAffinity` attributes). Watch-out: share-receive and
deep-link flows need a manual retest, since task placement for incoming
intents changed with MainActivity's affinity.

## Appendix: log fingerprints- Clean cancel: `browser flow started` → `cancelled by user` →
  `browser step cancelled, no token to exchange`.
- Race/drop: `browser flow started` → `failed with platform error
  null_intent` (+ `Failed to authorize: Null intent received`), no
  lifecycle gap (alive) or with cold start (dead).
- Relay receipt: `SSO redirect observed at <ts> (code: true, state:
  true, error: false)` — proves arrival with a redeemable code.
- Interruption resume: `Resuming interrupted SSO for <id> in WebView
  fallback mode` + `ssoLoginInterrupted` notice on next cold start.

# Native SSO (system-browser direct flow) — debugging record

Goal: log in via the system browser (AppAuth PKCE, no secrets in the app)
against paperless-ngx v3 + authentik, instead of the in-app WebView fallback.

**Status (2026-10-31, session 2):** the app-side redirect chain is FIXED and
proven end-to-end on a clean task: the response now reaches the tap-time
Management via `onNewIntent` and the token exchange starts. The sole
remaining blocker is server-side: authentik's `paperless` OIDC client is
CONFIDENTIAL and rejects the app's public-PKCE exchange with
`invalid_client` (reproduced standalone via curl; see §"Session 2").
A bbone-infra subagent has been dispatched to flip the client to Public.
Session-1 status, for the record (2026-10-29): redirect reached the phone
with a valid `code`+`state`, but the chain resolved it as
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

## ADB era verdict: stateless Management at response time (session 1 end state — RETRACTED, see "Session 2")

With the phone on ADB, the full chain was watched live: tap →
Management STARTs → browser opens → instant redirect → relay records
`code+state, no error` → forwards → receiver → Management response →
**`W/AppAuth: No stored state - unable to handle response`** → silent
finish. No cancel, no crash, no tokens, process and MainActivity alive
throughout. The tap-time Management instance is gone within ~1–2s every
run; the response always meets a fresh stateless one. "Don't keep
activities" is OFF and exit history shows no kills, so the destroyer is
still unidentified — translucent-background reclaim on this device/OS
build is the leading suspect, unproven.

## Session 2 (2026-10-31): no destroyer exists — split task was stale-state; real wall is authentik

Full instrumentation (unfiltered logcat + ~0.7s-cadence on-device
`dumpsys activity activities` loop) across three live runs gave a complete
event spine. Two findings closed every open question from session 1:

**1. The "destroyer of tap-time Management" was a phantom.** Management is
never destroyed. In the failing runs the response chain simply ran in a
*different task* than the stateful Management:

- Tap → Management (with extras) + Firefox custom tab land in the app task
  (#29780) — `dumpsys` snapshots during the browser window show the
  stateful instance alive under the tab the whole time.
- Redirect → Firefox fires the VIEW intent with `flg=0x14000000`
  (NEW_TASK|CLEAR_TOP) from the custom tab. In failing runs Android
  **created a brand-new task (#29782)** for `SsoRedirectActivity` instead
  of joining the app task; relay → receiver → response-Management (all
  affinity-placid) then stayed in #29782, so `createResponseHandlingIntent`
  (CLEAR_TOP|SINGLE_TOP, no NEW_TASK) spawned a stateless clone there →
  `W/AppAuth: No stored state` → silent finish → user back-press closes
  the tab → *real* Management resumes with no data → honest
  `cancelled by user`. Every session-1 fingerprint explained.

- Why the new task: the app task in those runs was **#29780, a stale task
  created before the shared-affinity fix** (root = MainActivity with the
  old empty `taskAffinity`, born from a PDF SEND share). Firefox's
  NEW_TASK affinity search found no root-affinity match → new task.
  After `am force-stop` (fresh task #29783, root affinity = package),
  the SAME build routes the redirect **into the app task**: receiver
  START, then `START … AuthorizationManagementActivity … result code=3`
  (START_DELIVERED_TO_TOP = onNewIntent to the live stateful instance!),
  no "No stored state", and MainActivity received the result. The
  session-1 "final relay design" is correct as shipped — it was being
  tested on a poisoned task.

- Practical consequence: any app task whose root predates the affinity
  fix (or any task whose root affinity ≠ package) still maroons the
  redirect. `am force-stop` / app restart clears it. A hardening option
  exists if this ever matters for upgrading users: have the relay forward
  *directly* to Management via
  `AuthorizationManagementActivity.createResponseHandlingIntent(...)` plus
  `FLAG_ACTIVITY_NEW_TASK` — singleTask *instance* lookup routes to the
  live Management regardless of task affinity. Not implemented: current
  build is proven on clean tasks and the change couldn't be live-tested
  in isolation (any real flow now completes to the exchange step).

**2. The real wall: authentik rejects the token exchange — `invalid_client`.**
With routing fixed, the flow reached the PKCE code exchange for the first
time, and authentik answered:

```
Failed to authorize: [error: invalid_client, description: Client
authentication failed (e.g., unknown client, no client authentication
included, or unsupported authentication method)]
```

Standalone reproduction (no app involved):

```
curl -s -X POST "https://idp.example.com/application/o/token/" \
  -d grant_type=authorization_code \
  -d client_id=<client_id-from-headless-config> \
  -d code=fakecode -d redirect_uri=paperlessmobile://oidc-callback \
  -d code_verifier=fakeverifier…
# → {"error": "invalid_client", … } HTTP 400
```

Root cause: discovery for the application
(`https://idp.example.com/application/o/paperless/.well-known/openid-configuration`)
advertises `token_endpoint_auth_methods_supported:
['client_secret_post', 'client_secret_basic']` — a confidential client
requiring a secret. The app is (correctly, by design) a public PKCE S256
client with no secret; flutter_appauth's `authorizeAndExchangeCode`
exchanges with `client_id` form-param only. Authentik supports S256 PKCE
server-wide, so the fix is to make the client Public (authentik then
enforces PKCE — fine, the app already sends S256 challenges).

Decision (Jeremy): flip the authentik `paperless` provider to Public via a
bbone-infra subagent (branch `authentik-paperless-public-client`), keep
everything else untouched, record the old client secret for revert, then:
(a) retest the app's direct flow end-to-end, (b) retest the paperless-ngx
web SSO login (its server-side flow uses the secret and may break →
revert if so).

Post-flip success fingerprint to watch for (logcat):

- `START … AuthorizationManagementActivity … result code=3` (delivered to
  top, no "No stored state")
- flutter: `AppAuth browser flow returned tokens (id …, access …)`
- flutter: `SSO exchange succeeded.` → `OidcSuccess` (paperless headless
  `/app/v1/auth/provider/token` mints the DRF token)

## Verdict table (entire investigation)

| Hypothesis | Verdict |
|---|---|
| Server missing headless | FALSE — serves config with client data, no flag needed |
| `redirect_uri` unregistered | FALSE — redirects fire every attempt |
| Missing receiver declaration | FALSE — binary-verified, exactly one resolver |
| MainActivity hijack (original bug) | TRUE, fixed (receiver declaration) |
| CLEAR_TOP murder by relay | TRUE, fixed (no finishing launches) |
| Duplicate MainActivity/tasks | TRUE, fixed (no MainActivity launches at all) |
| Affinity-split tasks | TRUE as observed; mitigated via shared package affinity |
| Firefox tab death | FALSE — every null traced to task splits or our own launches |
| OS memory kill | FALSE for test windows (exit history clean, process alive) |
| Don't-keep-activities | FALSE (off on device) |
| IdP rejecting exchange (confidential client) | TRUE — session 2: exchange reached, `invalid_client`, curl-reproduced; discovery advertises secret-only auth methods |
| Management dead at response time | FALSE — session 2: never destroyed; stateless clone in a split task met the response. Session-1 conclusion retracted |
| Translucent-background reclaim (session-1 suspect) | FALSE — no destroyer exists |
| Firefox-vs-Chrome engine difference | MOOT — clean-task routing works with Firefox; browser is not a variable |
| Stale pre-fix app task breaks redirect routing | TRUE — proven live; cleared by force-stop/restart (see session 2 §1) |

## Open questions (next session)

1. Authentik client flip (bbone-infra subagent, branch
   `authentik-paperless-public-client`): applied and verified against the
   discovery doc? If yes →
2. Retest the app's direct flow end-to-end on the phone (expect
   `SSO exchange succeeded.` + `OidcSuccess`).
3. Retest paperless-ngx **web** SSO login after the flip (its server-side
   flow uses the client secret; revert instructions should be in the
   subagent's report if it breaks).
4. Optional hardening (not urgent, see session 2 §1): relay forwards
   directly to Management (`createResponseHandlingIntent` + NEW_TASK) so
   redirect routing survives any task-affinity oddity. Needs a live test
   plan before implementing.

## Appendix: log fingerprints

- Clean cancel: `browser flow started` → `cancelled by user` →
  `browser step cancelled, no token to exchange`.
- Race/drop: `browser flow started` → `failed with platform error
  null_intent` (+ `Failed to authorize: Null intent received`), no
  lifecycle gap (alive) or with cold start (dead).
- Relay receipt: `SSO redirect observed at <ts> (code: true, state:
  true, error: false)` — proves arrival with a redeemable code.
- Interruption resume: `Resuming interrupted SSO for <id> in WebView
  fallback mode` + `ssoLoginInterrupted` notice on next cold start.
- Split-task drop (session 1, stale task): Firefox START of
  `SsoRedirectActivity` resolved into a NEW task id ≠ app task →
  `W/AppAuth: No stored state - unable to handle response`.
- Delivered-to-top success (session 2, clean task): `START …
  AuthorizationManagementActivity … result code=3` with no
  `No stored state`, followed by the exchange outcome in flutter logs.
- Exchange rejected by IdP: `Failed to authorize: [error: invalid_client,
  description: Client authentication failed …]` — routing is healthy;
  authentik client type is the problem.

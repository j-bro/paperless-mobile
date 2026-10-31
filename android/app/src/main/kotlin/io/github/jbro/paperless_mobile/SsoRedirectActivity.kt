package io.github.jbro.paperless_mobile

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import java.io.File
import org.json.JSONObject

/**
 * Relay for the OIDC custom-scheme callback (`paperlessmobile://oidc-callback`).
 *
 * Why this exists at all: the implicit VIEW intent must resolve to exactly
 * one activity (verified via `aapt dump xmltree`: this relay is the sole
 * filter holder; the stock receiver is kept filter-less).
 *
 * What it does, in order — and just as importantly what it does NOT do:
 * 1. Records the receipt (logcat `SsoRedirect` + `sso_redirect_observation.json`,
 *    drained by [drainRedirectObservation]). Metadata only, never secrets.
 * 2. Forwards the redirect to the stock receiver WITH new-task semantics so
 *    the receiver lands in the package-affinity task — the same task the
 *    singleTask AuthorizationManagementActivity always lives in. That is the
 *    load-bearing detail (proven live via dumpsys): without it the response
 *    spawns a fresh stateless Management in a stray task that silently
 *    drops it, while the stateful instance waits forever in another task.
 * 3. Launches nothing else and finishes nothing else. In particular it never
 *    touches MainActivity: every variant tried (CLEAR_TOP, REORDER, plain
 *    launch) either finished the working Management or forked a second
 *    MainActivity/second task, splitting response and waiter apart. The
  *    VIEW intent itself foregrounds whatever task needs it; outcomes
  *    surface through the app UI (navigation when foreground, snackbar
  *    fallback prompt on errors).
 * What it must NEVER do (each burned us once, proven by device logs):
 * - CLEAR_TOP anything: finishes the still-working ManagementActivity,
 *   whose cancellation propagates as a null result (~130ms after receipt).
 * - Rely on task affinity matching: empty affinity never joins empty
 *   affinity, so "same task" assumptions and isTaskRoot gates lie.
 * - Treat the observation file as completion data: without the in-memory
 *   PKCE verifier the code cannot be redeemed; diagnosis only.
 *
 * Cold start (no app task at all): MainActivity boots fresh and the
 * persisted-attempt recovery ([resumeInterruptedSso]) takes over on
 * restore; the stateless Management drops the response as designed.
 *
 * Never throws: a crashing redirect handler would strand the login the
 * same way the old behavior did.
 */
class SsoRedirectActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        try {
            val redirect = intent?.data
            recordRedirectObservation(this, redirect)
            // Stock AppAuth delivery, routed to Management's task: the
            // NEW_TASK flag joins the receiver to the package-affinity
            // task where the singleTask Management instance lives, so
            // the response CLEAR_TOP finds the stateful instance instead
            // of spawning a stateless one that silently drops it.
            // Deliberately NO MainActivity launch of any kind here: every
            // variant tried (CLEAR_TOP, REORDER, plain) either finished the
            // still-working Management or forked a second MainActivity into
            // a second task, splitting response and waiter apart. Terminal
            // outcomes surface through the app's own channels (navigation
            // when foreground, snackbar fallback prompt on errors).
            if (redirect != null) {
                val forward = Intent().apply {
                    setClassName(
                        this@SsoRedirectActivity,
                        "net.openid.appauth.RedirectUriReceiverActivity",
                    )
                    action = Intent.ACTION_VIEW
                    data = redirect
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                startActivity(forward)
            }
        } catch (_: Exception) {
            // Best-effort only: never crash the login handoff.
        } finally {
            finish()
        }
    }

    companion object {
        private const val TAG = "SsoRedirect"
        private const val OBSERVATION_FILE = "sso_redirect_observation.json"

        /**
         * Records redirect *metadata* (never secret values) to logcat and to
         * [OBSERVATION_FILE] in [Activity.cacheDir] — the same directory
         * Dart's path_provider reports, so no path conventions are shared.
         * The Dart side drains and logs the file; a stale file means the
         * redirect arrived but the app never processed it.
         */
        fun recordRedirectObservation(activity: Activity, redirect: Uri?) {
            try {
                val error = redirect?.getQueryParameter("error")
                val detail =
                    "scheme=${redirect?.scheme} host=${redirect?.host} " +
                        "hasCode=${redirect?.getQueryParameter("code") != null} " +
                        "hasState=${redirect?.getQueryParameter("state") != null} " +
                        "hasError=${error != null} error=$error"
                Log.d(TAG, "SSO redirect received: $detail")
                val observation =
                    JSONObject()
                        .put("receivedAtMillis", System.currentTimeMillis())
                        .put("scheme", redirect?.scheme)
                        .put("host", redirect?.host)
                        .put(
                            "hasCode",
                            redirect?.getQueryParameter("code") != null,
                        )
                        .put(
                            "hasState",
                            redirect?.getQueryParameter("state") != null,
                        )
                        .put("hasError", error != null)
                        .put("error", error)
                File(activity.cacheDir, OBSERVATION_FILE).writeText(
                    observation.toString(),
                )
            } catch (_: Exception) {
                // Diagnostics must never break the handoff.
            }
        }
    }
}

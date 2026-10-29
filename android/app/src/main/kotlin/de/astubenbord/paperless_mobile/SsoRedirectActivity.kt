package de.astubenbord.paperless_mobile

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
 * Stock AppAuth delivers the redirect to `RedirectUriReceiverActivity`,
 * which is transparent: when the app process is still alive that is fine
 * (the visible [MainActivity] is already there and the pending Dart future
 * completes). But when the OS killed the app during the browser round-trip,
 * the redirect cold-starts *only* the transparent receiver, which finds no
 * pending state, finishes instantly — and Android falls back to the browser.
 * The user sees the app flash and vanish with no error and no way forward.
 *
 * This relay runs first instead: it records the receipt (see below),
 * brings the existing [MainActivity] forward WITHOUT disturbing the stack
 * (REORDER_TO_FRONT), and forwards the redirect to the stock receiver.
 * Foregrounding matters: after the handoff the user must watch the
 * spinner/outcome instead of a blank browser tab, which they back out of —
 * cancelling an exchange that was about to succeed. CLEAR_TOP must never
 * be used here: it would finish the still-working
 * AuthorizationManagementActivity, whose cancellation propagates as a null
 * result and drops the just-arrived response (observed: null ~130ms after
 * every receipt while the redirect itself carried code+state). Cold start
 * simply creates [MainActivity], after which restore + resume logic
 * ([resumeInterruptedSso]) run as usual.
 *
 * Diagnostics: every receipt is recorded (logcat `SsoRedirect`, plus
 * `cacheDir/sso_redirect_observation.json` drained and logged by
 * [drainRedirectObservation] on the Dart side). Only redirect *metadata*
 * is recorded — presence of code/state, error code — never secret values.
 * The file is diagnostic only: without the in-memory PKCE verifier the
 * code cannot be redeemed, so it must never be treated as completion data.
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
            // Bring the existing MainActivity forward WITHOUT disturbing
            // the stack: the user must watch the spinner/outcome instead
            // of a blank browser tab (which they back out of, cancelling
            // an exchange that was about to succeed). REORDER_TO_FRONT
            // reuses the instance; CLEAR_TOP must never be used here — it
            // would finish AuthorizationManagementActivity mid-processing.
            // Cold start simply creates MainActivity (restore + resume run).
            val main = Intent(this, MainActivity::class.java).apply {
                action = Intent.ACTION_MAIN
                addCategory(Intent.CATEGORY_LAUNCHER)
                addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP or
                        Intent.FLAG_ACTIVITY_REORDER_TO_FRONT,
                )
            }
            startActivity(main)
            // Stock AppAuth delivery (explicit intent, so it works even
            // though the library receiver has no filter).
            if (redirect != null) {
                val forward = Intent().apply {
                    setClassName(
                        this@SsoRedirectActivity,
                        "net.openid.appauth.RedirectUriReceiverActivity",
                    )
                    action = Intent.ACTION_VIEW
                    data = redirect
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

package de.astubenbord.paperless_mobile

import android.app.Activity
import android.content.Intent
import android.os.Bundle

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
 * This relay runs first instead: it always brings the visible app forward
 * AND forwards the redirect to the stock receiver, so the alive case keeps
 * working exactly as before while the dead case lands in [MainActivity],
 * where startup recovery ([resumeInterruptedSso], driven by the persisted
 * attempt flag) takes over.
 *
 * Never throws: a crashing redirect handler would strand the login the
 * same way the old behavior did.
 */
class SsoRedirectActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        try {
            val redirect = intent?.data
            // 1. Visible app forward, so the user never ends up back in the
            //    browser with no UI. Cold start runs restore + resume logic.
            val main = Intent(this, MainActivity::class.java).apply {
                action = Intent.ACTION_MAIN
                addCategory(Intent.CATEGORY_LAUNCHER)
                addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP,
                )
            }
            startActivity(main)
            // 2. Stock AppAuth delivery for the alive case (explicit intent,
            //    so it works even though the library receiver has no filter).
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
}

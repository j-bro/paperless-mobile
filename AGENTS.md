# AGENTS.md

This is a fork of `astubenbord/paperless-mobile` (GPL-3.0), published by
`j-bro/paperless-mobile` as **Paperless Mobile Fork** via GitHub releases only
(no Play Store).

## Fork identity — do not regress

| Surface | Value |
|---|---|
| Android `applicationId` / `namespace` (`android/app/build.gradle.kts`) | `io.github.jbro.paperless_mobile` (+ `.debug` suffix for debug builds) |
| Android `MainActivity` | `android/app/src/main/kotlin/io/github/jbro/paperless_mobile/MainActivity.kt`, package `io.github.jbro.paperless_mobile` |
| Android label (`AndroidManifest.xml`) | `Paperless Mobile Fork` |
| Fastlane `Appfile` / `Fastfile` repo | `io.github.jbro.paperless_mobile` / `j-bro/paperless-mobile` (legacy lanes, not used by CI) |
| iOS bundle IDs (`project.pbxproj`) | `io.github.jbro.paperless-mobile`, share extension `... .receive-sharing-intent` |
| iOS app groups (both `.entitlements`) + `ShareViewController.hostAppBundleIdentifier` | `group.io.github.jbro.paperless-mobile` / `io.github.jbro.paperless-mobile` |
| iOS display name (`ios/Runner/Info.plist`) | `Paperless Mobile Fork` |
| Dart package (`pubspec.yaml`, `package:paperless_mobile` imports) | Unchanged — internal only, never rename |

The new IDs allow side-by-side install with upstream. Changing them back to
`de.astubenbord.*` breaks that — don't.

## Commit conventions

- Conventional Commits, lowercase imperative after the colon:
  `feat:`, `fix:`, `chore:`, `refactor:`, `test:`, `docs:`, `ci:`.
  - Good: `feat: add public share-link manager sheet`, `fix: bound public share sheet height`, `chore: bump version`
  - Bad: `Feat:`, `fixed bug`, `WIP`, `update stuff`
- One logical change per commit; small focused commits over mega-commits.
- Branches: `feat/<name>`, `fix/<name>`, `chore/<name>`. PRs target the fork default branch.
- Every PR runs `.github/workflows/pr-check.yml` (analyze + test + debug APK). Keep it green; don't weaken it to land faster.
- GPL: commits are the modification record — write messages that explain what changed vs upstream.

## Cutting a release (GitHub releases only)

Workflow: **Actions → Create Release APK** (`.github/workflows/release-apk.yml`, `workflow_dispatch`).

| Input | Use |
|---|---|
| `tag` | Required. Scheme `v<upstream-version>-fork.<n>`, e.g. `v4.5.0-fork.1`. Never reuse a tag. |
| `draft` | Keep `true`; review then publish manually. |
| `prerelease` | `true` for test builds, `false` for stable fork releases. |

Before dispatch:

1. Bump `version: x.y.z+N` in `pubspec.yaml` so it matches the tag's intent.
2. Merge to the default branch; dispatch from there.

The workflow builds `flutter build apk --release` (universal APK, no Fastlane/Ruby),
renames it to `paperless-mobile-<tag>.apk`, and creates the release with
`generate_release_notes: true` (GitHub auto-notes from merged PRs).

Release-notes checklist (edit the draft before publishing):

1. **Fork attribution (GPL §4/§5):** first line states this is a modified fork of
   `astubenbord/paperless-mobile`, e.g. `Fork of astubenbord/paperless-mobile v4.5.0 with share-link management.`
2. **Delta list:** user-facing fork changes since the last fork tag (the auto-notes cover PR titles — curate, don't dump).
3. **Install note:** side-by-side installable with upstream (`io.github.jbro.*` vs `de.astubenbord.*`); reinstall/wipe required if the signing key changed (see below).
4. Keep the attached `paperless-mobile-<tag>.apk`; don't attach debug APKs.

## Signing note

- With the 5 keystore secrets set (`KEYSTORE_*`, `RELEASE_KEYSTORE*`), the workflow reuses `.github/actions/setup-android-signing-config` for a properly signed APK.
- Without secrets it falls back to an ephemeral self-signed keystore so the build still succeeds — fine for testing, but users must reinstall (not update) when switching between ephemeral and real keys. Never publish a stable release off an ephemeral key and a later stable off a real key under the same tag.

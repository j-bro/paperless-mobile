---
name: version
description: Bumps the app version (major, minor, or patch) in pubspec.yaml, increments the build number by 10, creates fastlane changelog stubs with generated release notes from git history, and registers the new build number in _versionNumbers. Use this when releasing a new version of paperless-mobile.
---

# Version Bump Skill

## Trigger

Use this skill when the user types `/version <major|minor|patch>`.

## Overview

This skill automates the version bump workflow for the paperless-mobile Flutter app. It:

1. Reads and bumps the semantic version in `pubspec.yaml`
2. Increments the build number by 10
3. Collects `feat` and `fix` commits since the latest git tag and generates human-readable release notes in English
4. Discovers available locale directories under `android/fastlane/metadata/android/`, writes the English notes for `en-US`, and translates them for each additional locale
5. Registers the new Android version code in `_versionNumbers` inside `changelog_dialog.dart`

## Version Format

The `version` field in `pubspec.yaml` follows the format:

```
<major>.<minor>.<patch>+<buildNumber>
```

Example: `4.0.3+570`

The **Android version code** used for release artifacts and file naming is derived by appending `3` to the build number:

```
androidVersionCode = "<buildNumber>3"
```

For example, build number `570` → Android version code `5703`.

## Step-by-Step Workflow

### Step 1: Parse the Current Version

Read `pubspec.yaml` and extract the `version` field:

```
version: <major>.<minor>.<patch>+<buildNumber>
```

Use `grep "^version:" pubspec.yaml` or read the file directly.

### Step 2: Compute the New Version

Based on the argument provided by the user (`major`, `minor`, or `patch`):

- **patch**: increment the patch number, keep major and minor. Reset nothing.
  - e.g. `4.0.3` → `4.0.4`
- **minor**: increment the minor number, reset patch to 0.
  - e.g. `4.0.3` → `4.1.0`
- **major**: increment the major number, reset minor and patch to 0.
  - e.g. `4.0.3` → `5.0.0`

Always increment the build number by **exactly 10**, regardless of bump type:

- e.g. `570` → `580`

The new version string becomes:

```
<newMajor>.<newMinor>.<newPatch>+<newBuildNumber>
```

### Step 3: Compute the New Android Version Code

```
newAndroidVersionCode = "<newBuildNumber>3"
```

Example: build number `580` → Android version code `5803`.

### Step 4: Update `pubspec.yaml`

Replace the old version line with the new one. Use `replace_string_in_file` on the exact line:

```
version: <old_version_string>
```

→

```
version: <new_version_string>
```

### Step 5: Collect Commits and Generate Release Notes

Run the following command to find the latest git tag and list all `feat` and `fix` commits since then:

```sh
git log $(git describe --tags --abbrev=0)..HEAD --oneline
```

From the output, filter only lines that start with `feat` or `fix` (conventional commit format). Ignore all other types (chore, refactor, docs, test, ci, build, etc.).

For each matching commit, rewrite the message as a short, plain-language bullet point suitable for end users:

- Remove the conventional commit prefix (`feat:`, `fix:`, `feat(scope):`, etc.)
- Remove technical jargon, references to internal code names, function names, or file names
- Describe **what the user can now do** or **what problem was fixed**, not how it was implemented
- Keep each bullet to one sentence, starting with a capital letter, no trailing period

Compile the results into a bulleted list, for example:

```
- Documents can now be filtered by custom fields
- Fixed a crash when opening the document scanner on some devices
```

If no `feat` or `fix` commits are found, fall back to the placeholder content:

```
-
```

### Step 6: Create Fastlane Changelog Files

#### 6a: Discover locales

List the available locale directories under `android/fastlane/metadata/android/`. Each subdirectory name is a locale code (e.g. `en-US`, `de-DE`). Use:

```sh
ls android/fastlane/metadata/android/
```

Treat `en-US` as the **primary locale**. All other locale directories are **secondary locales** that require translation.

#### 6b: Write the English changelog

Create `android/fastlane/metadata/android/en-US/changelogs/<newAndroidVersionCode>.txt` with the English bullet list generated in Step 5.

#### 6c: Translate and write each secondary locale

For each secondary locale directory (e.g. `de-DE`), translate the English bullet list into that locale's language. Apply the same rules as Step 5 when translating:

- Plain, friendly language suitable for end users
- One sentence per bullet, starting with a capital letter, no trailing period
- Preserve the `- ` prefix on each line

Create `android/fastlane/metadata/android/<locale>/changelogs/<newAndroidVersionCode>.txt` with the translated content.

If no `feat` or `fix` commits were found (placeholder fallback), write the same `- ` placeholder for all locales without translating.

### Step 6: Register the New Version in `_versionNumbers`

In `lib/features/changelogs/view/changelog_dialog.dart`, add a new entry at the **top** of the `_versionNumbers` map.

The current top entry looks like:

```dart
const _versionNumbers = {
  "<oldAndroidVersionCode>": "<oldSemanticVersion>",
```

Replace it with:

```dart
const _versionNumbers = {
  "<newAndroidVersionCode>": "<newSemanticVersion>",
  "<oldAndroidVersionCode>": "<oldSemanticVersion>",
```

Where:

- `newAndroidVersionCode` = `<newBuildNumber>3` (e.g., `"5803"`)
- `newSemanticVersion` = new semantic version string (e.g., `"4.0.4"`)

### Step 7: Report the Result

After completing all changes, summarize what was done:

```
Bumped version: <oldVersion> → <newVersion>
Build number:   <oldBuild> → <newBuild>
Android code:   <oldAndroidCode> → <newAndroidCode>

Release notes:
<generated bullet list, or "No feat/fix commits found." if empty>

Files updated:
- pubspec.yaml
- lib/features/changelogs/view/changelog_dialog.dart
- android/fastlane/metadata/android/en-US/changelogs/<newAndroidCode>.txt (created)
- android/fastlane/metadata/android/<locale2>/changelogs/<newAndroidCode>.txt (created, translated)
- ... (one entry per discovered locale)
```

## Example

Given current `version: 4.0.3+570` and argument `patch`, with two relevant commits since the last tag:

- New semantic version: `4.0.4`
- New build number: `580`
- New Android version code: `5803`
- New pubspec version line: `version: 4.0.4+580`
- Generated release notes (from `feat`/`fix` commits):
  ```
  - Documents can now be filtered by custom fields
  - Fixed a crash when opening the document scanner on some devices
  ```
- Discovered locale dirs: `en-US`, `de-DE` (example)
- New changelog files:
  - `en-US/changelogs/5803.txt` — English notes as generated
  - `de-DE/changelogs/5803.txt` — German translation of the same notes
- New `_versionNumbers` entry: `"5803": "4.0.4"`

## Important Notes

- The `_versionNumbers` map is `const` at the bottom of `changelog_dialog.dart`.
- Always insert the new entry as the **first** entry in the map (top of the list).
- Only `feat` and `fix` conventional commit types are included in release notes. All other types (`chore`, `refactor`, `docs`, `test`, `ci`, `build`, etc.) are ignored.
- Rewrite commit messages in plain language for end users — avoid technical terms, scope tags, issue references, and code names.
- If no qualifying commits are found, fall back to the `- ` placeholder in all changelog files (no translation needed).
- Always discover locale directories at runtime — do not hardcode locale codes.
- `en-US` is always the primary locale. Every other locale directory receives a translated version of the English notes.
- Never guess the version; always read it fresh from `pubspec.yaml` before computing.

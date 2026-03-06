---
name: version
description: Bumps the app version (major, minor, or patch) in pubspec.yaml, increments the build number by 10, creates fastlane changelog stubs, and registers the new build number in _versionNumbers. Use this when releasing a new version of paperless-mobile.
---

# Version Bump Skill

## Trigger

Use this skill when the user types `/version <major|minor|patch>`.

## Overview

This skill automates the version bump workflow for the paperless-mobile Flutter app. It:

1. Reads and bumps the semantic version in `pubspec.yaml`
2. Increments the build number by 10
3. Creates placeholder changelog files for both locales in fastlane metadata
4. Registers the new Android version code in `_versionNumbers` inside `changelog_dialog.dart`

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

### Step 5: Create Fastlane Changelog Files

Create the following two files with placeholder content:

- `android/fastlane/metadata/android/de-DE/changelogs/<newAndroidVersionCode>.txt`
- `android/fastlane/metadata/android/en-US/changelogs/<newAndroidVersionCode>.txt`

Content for both files:
```
- 
```

(A single bullet point placeholder for the release notes.)

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

Files updated:
- pubspec.yaml
- lib/features/changelogs/view/changelog_dialog.dart
- android/fastlane/metadata/android/de-DE/changelogs/<newAndroidCode>.txt (created)
- android/fastlane/metadata/android/en-US/changelogs/<newAndroidCode>.txt (created)
```

## Example

Given current `version: 4.0.3+570` and argument `patch`:

- New semantic version: `4.0.4`
- New build number: `580`
- New Android version code: `5803`
- New pubspec version line: `version: 4.0.4+580`
- New changelog files: `5803.txt` in both locale dirs
- New `_versionNumbers` entry: `"5803": "4.0.4"`

## Important Notes

- The `_versionNumbers` map is `const` at the bottom of `changelog_dialog.dart`.
- Always insert the new entry as the **first** entry in the map (top of the list).
- The changelog `.txt` files should be created as stubs — the user will fill in the release notes manually.
- Never guess the version; always read it fresh from `pubspec.yaml` before computing.

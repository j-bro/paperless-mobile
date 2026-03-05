#!/usr/bin/env bash
set -Euo pipefail

__script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly __script_dir

cd "$__script_dir/../"

dart pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
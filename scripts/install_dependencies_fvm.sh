#!/usr/bin/env bash
set -Euo pipefail

__script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly __script_dir

cd "$__script_dir/../"

fvm dart pub get
fvm flutter gen-l10n
fvm dart run build_runner build --delete-conflicting-outputs

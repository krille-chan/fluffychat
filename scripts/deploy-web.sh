#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Joshua Schell
# SPDX-License-Identifier: AGPL-3.0-or-later
#
# Build the web release and deploy it to Cloudflare Pages
# (project: schellout-chat → https://chat.schellout.com).
#
# AGPL §13 note: always push the source branch before/with a deploy so the
# published build matches public source at github.com/jschell12/schellout-chat.

set -euo pipefail

cd "$(dirname "$0")/.."

PROJECT="${PAGES_PROJECT:-schellout-chat}"
FLUTTER="${FLUTTER:-flutter}"
if [ -x .fvm/flutter_sdk/bin/flutter ]; then
  FLUTTER=.fvm/flutter_sdk/bin/flutter
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "WARNING: working tree is dirty — deployed build may not match pushed source." >&2
fi

# Web-only artifacts produced by scripts/prepare-web.sh (gitignored). Without
# them the deployed app renders a blank page: vodozemac wasm is required for
# E2EE, Imaging.js for image handling, native_executor.js for workers.
required_artifacts=(
  assets/vodozemac/vodozemac_bindings_dart.js
  assets/vodozemac/vodozemac_bindings_dart_bg.wasm
  web/Imaging.js
  web/Imaging.wasm
  web/native_executor.js
)
missing=0
for f in "${required_artifacts[@]}"; do
  if [ ! -f "$f" ]; then
    echo "ERROR: missing web artifact: $f" >&2
    missing=1
  fi
done
if [ "$missing" -ne 0 ]; then
  echo "Run scripts/prepare-web.sh first (needs yq, rustup + wasm toolchain)." >&2
  echo "Without rustup: fetch vodozemac bindings from a matching upstream web" >&2
  echo "build, download native_imaging.zip from famedly/dart_native_imaging" >&2
  echo "releases, and 'dart compile js web/native_executor.dart -o web/native_executor.js -m'." >&2
  exit 1
fi

"$FLUTTER" build web --release

for f in build/web/Imaging.js build/web/native_executor.js \
  build/web/assets/assets/vodozemac/vodozemac_bindings_dart.js; do
  if [ ! -f "$f" ]; then
    echo "ERROR: $f missing from build output — aborting deploy." >&2
    exit 1
  fi
done

npx --yes wrangler pages deploy build/web \
  --project-name "$PROJECT" \
  --branch main \
  --commit-hash "$(git rev-parse HEAD)" \
  --commit-dirty=false

echo "Deployed $(git rev-parse --short HEAD) to Cloudflare Pages project '$PROJECT'."

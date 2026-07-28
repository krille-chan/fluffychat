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

"$FLUTTER" build web --release

npx --yes wrangler pages deploy build/web \
  --project-name "$PROJECT" \
  --branch main \
  --commit-hash "$(git rev-parse HEAD)" \
  --commit-dirty=false

echo "Deployed $(git rev-parse --short HEAD) to Cloudflare Pages project '$PROJECT'."

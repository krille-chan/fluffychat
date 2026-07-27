#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Joshua Schell
# SPDX-License-Identifier: AGPL-3.0-or-later
#
# pub.dev strips symlinks when publishing packages, which flattens the macOS
# framework bundle inside flutter_vodozemac's xcframework. codesign then fails
# with "code object is not signed at all" because Versions/Current is a real
# directory instead of a symlink. This restores the canonical framework
# symlink structure in the pub cache. Run once per machine / after the
# package version changes, then delete macos/Flutter/ephemeral and rebuild.
#
# See BRANDING.md (schellout-chat fork).

set -euo pipefail

PUB_CACHE="${PUB_CACHE:-$HOME/.pub-cache}"

find "$PUB_CACHE/hosted" -maxdepth 2 -type d -name 'flutter_vodozemac-*' | while read -r pkg; do
  find "$pkg" -type d -name '*.framework' | while read -r fw; do
    [ -d "$fw/Versions/A" ] || continue
    [ -L "$fw/Versions/Current" ] && continue # already fixed
    echo "Fixing framework symlinks: $fw"
    rm -rf "$fw/Versions/Current"
    ln -s A "$fw/Versions/Current"
    for entry in "$fw"/Versions/A/*; do
      name="$(basename "$entry")"
      rm -rf "${fw:?}/$name"
      ln -s "Versions/Current/$name" "$fw/$name"
    done
  done
done

echo "Done. If you have built before, remove the stale ephemeral copy:"
echo "  rm -rf macos/Flutter/ephemeral"

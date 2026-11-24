#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2019-Present Christian Kußowski
# SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# Downloads the prebuilt native vodozemac library for running tests on this host.
set -e
version=$(yq ".packages.vodozemac.version" < pubspec.lock | tr -d '"')
case "$(uname -s)-$(uname -m)" in
  Linux-x86_64) asset=linux-x64.so ext=so ;;
  Linux-aarch64 | Linux-arm64) asset=linux-arm64.so ext=so ;;
  Darwin-*) asset=macos.dylib ext=dylib ;;
  *) echo "No prebuilt vodozemac for $(uname -s)-$(uname -m)" >&2 && exit 1 ;;
esac
mkdir -p test/vodozemac
curl -fsSL "https://github.com/famedly/dart-vodozemac/releases/download/v${version}/libvodozemac_bindings_dart-${asset}" \
  -o "test/vodozemac/libvodozemac_bindings_dart.${ext}"

#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2019-Present Christian Kußowski
# SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
#
# SPDX-License-Identifier: AGPL-3.0-or-later

set -e
version=$(yq ".packages.vodozemac.version" pubspec.lock)
rm -rf ./test/rust dart-vodozemac
git clone https://github.com/famedly/dart-vodozemac.git -b "$version"
mv ./dart-vodozemac/rust ./test/
rm -rf dart-vodozemac
cd ./test/rust && cargo build && cd ../..
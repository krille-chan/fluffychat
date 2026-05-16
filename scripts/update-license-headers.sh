#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2019-Present Christian Kußowski
# SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
#
# SPDX-License-Identifier: AGPL-3.0-or-later

find . -type f \
    -not -path "*/.*" \
    -not -path "*/*.json" \
    -not -path "*/pubspec.lock" \
    -not -path "*/build/*" \
    -not -path "*/assets/*" \
    -not -path "*/lib/l10n/*" \
    -not -path "*/android/*" \
    -not -path "*/ios/*" \
    -not -path "*/linux/*" \
    -not -path "*/macos/*" \
    -not -path "*/LICENSE" \
    -not -path "*/LICENSES/*" \
    -not -path "*/integration_test/synapse/*" \
    -not -path "*/integration_test/data/*" \
    -not -path "*/snap/*" \
    -not -path "*/web/*" \
    -not -path "*/windows/*" \
    -exec reuse annotate \
    --copyright="Christian Kußowski" \
    --copyright="Contributors to FluffyChat" \
    --license="AGPL-3.0-or-later" \
    --year="2019-Present" \
    --merge-copyrights \
    {} +
#!/bin/sh -ve

# SPDX-FileCopyrightText: 2019-Present Christian Kußowski
# SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
#
# SPDX-License-Identifier: AGPL-3.0-or-later

SED=$(command -v gsed || command -v sed)

# Download prebuilt Vodozemac for web (must match the resolved vodozemac bindings)
version=$(yq ".packages.vodozemac.version" < pubspec.lock)
version=$(printf "%s" "$version" | tr -d '"')
curl -fsSLO "https://github.com/famedly/dart-vodozemac/releases/download/v${version}/vodozemac-web.zip"
mkdir -p "./assets/vodozemac/$version/"
unzip -o -q vodozemac-web.zip 'vodozemac_bindings_dart*' -d "./assets/vodozemac/$version/"
rm vodozemac-web.zip
grep -qF "assets/vodozemac/${version}/" pubspec.yaml || "$SED" -i "\|- assets/sounds/|a\\    - assets/vodozemac/${version}/" pubspec.yaml
"$SED" -i "s/vodozemacVersion = '.*';/vodozemacVersion = '${version}';/" lib/config/app_config.dart

flutter pub get
dart compile js ./web/native_executor.dart -o ./web/native_executor.js -m

# Download native_imaging for web:
version=$(yq ".dependencies.native_imaging" < pubspec.yaml)
version=$(printf "%s" "$version" | tr -d '"^')
curl -L "https://github.com/famedly/dart_native_imaging/releases/download/v${version}/native_imaging.zip" > native_imaging.zip
unzip native_imaging.zip
mv js/* web/
rmdir js
rm native_imaging.zip

# Enable e2ee for LiveKit:
git clone https://github.com/livekit/client-sdk-flutter.git
cd client-sdk-flutter
flutter pub get

# Patch so that LiveKit uses HKDF by default:
# Workaroudn for https://github.com/livekit/client-sdk-flutter/issues/974
"$SED" -i "s/{'name': 'PBKDF2'.toJS}/{'name': 'HKDF'.toJS}/g" web/e2ee.keyhandler.dart
"$SED" -i "s/getAlgoOptions('PBKDF2', salt)/getAlgoOptions('HKDF', salt)/g" web/e2ee.keyhandler.dart
"$SED" -i "s/{'name': 'PBKDF2'}/{'name': 'HKDF'}/g"           web/e2ee.utils.dart

dart compile js web/e2ee.worker.dart -o ../web/e2ee.worker.dart.js -m
cd ..
rm -rf client-sdk-flutter
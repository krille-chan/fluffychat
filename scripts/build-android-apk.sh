#!/usr/bin/env bash
/bin/bash ./scripts/prepare-android-release.sh
flutter channel stable
flutter upgrade
flutter pub get
flutter build apk --release
mkdir -p build/android
cp build/app/outputs/apk/release/app-release.apk build/android/

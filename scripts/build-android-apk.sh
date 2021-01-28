#!/usr/bin/env bash
flutter channel stable
flutter upgrade
flutter pub get
rm -rf android/.gradle
flutter build apk --release
mkdir -p build/android
cp build/app/outputs/apk/release/app-release.apk build/android/

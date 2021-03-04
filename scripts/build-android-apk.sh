#!/usr/bin/env bash
flutter pub get
flutter build apk --release
mkdir -p build/android
cp build/app/outputs/apk/release/app-release.apk build/android/

#!/usr/bin/env bash
/bin/bash ./scripts/prepare-android-release.sh
flutter channel stable
flutter upgrade
flutter pub get
flutter build appbundle --target-platform android-arm,android-arm64,android-x64
mkdir -p build/android
cp build/app/outputs/bundle/release/app-release.aab build/android/

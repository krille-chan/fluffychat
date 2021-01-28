#!/usr/bin/env bash
flutter channel stable
flutter upgrade
flutter pub get
flutter build apk --debug
flutter build apk --profile
flutter build apk --release
mkdir -p build/android
cp build/app/outputs/apk/release/app-release.apk build/android/

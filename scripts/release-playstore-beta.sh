#!/usr/bin/env bash
flutter pub get
flutter build appbundle --target-platform android-arm,android-arm64,android-x64
mkdir -p build/android
cp build/app/outputs/bundle/release/app-release.aab build/android/
cd android
bundle install
bundle update fastlane
bundle exec fastlane deploy_internal_test
cd ..

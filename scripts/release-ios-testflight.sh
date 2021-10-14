#!/bin/sh -ve
git apply ./scripts/enable-android-google-services.patch
flutter clean
flutter pub get
cd ios
pod install
pod update
cd ..
flutter build ios --release
cd ios
bundle install
bundle update fastlane
bundle exec fastlane beta
cd ..
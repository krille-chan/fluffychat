#!/bin/sh -ve
flutter pub add firebase_core
flutter pub add firebase_messaging
sed -i '' 's,//<GOOGLE_SERVICES>,,g' lib/utils/background_push.dart
flutter clean
flutter pub get
cd ios
rm -rf Pods
rm -f Podfile.lock
pod install
pod update
cd ..
flutter build ios --release
cd ios
bundle update fastlane
bundle exec fastlane beta
cd ..
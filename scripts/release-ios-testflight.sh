#!/bin/sh -ve
./scripts/enable-google-services.sh
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
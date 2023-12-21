#!/bin/sh -ve
./scripts/enable-google-services.sh
rm -rf fonts/NotoEmoji
yq -i 'del( .flutter.fonts[] | select(.family == "NotoEmoji") )' pubspec.yaml
flutter clean
flutter pub get
cd ios
rm -rf Pods
rm -f Podfile.lock
arch -x86_64 pod install
arch -x86_64 pod update
cd ..
flutter build ios --release
cd ios
bundle update fastlane
bundle exec fastlane beta
cd ..
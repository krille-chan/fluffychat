#!/bin/sh -ve
flutter channel stable
flutter upgrade
flutter clean
flutter pub get
cd ios
pod install
pod update
cd ..
flutter build ios --release

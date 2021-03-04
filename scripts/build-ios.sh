#!/bin/sh -ve
flutter clean
flutter pub get
cd ios
pod install
pod update
cd ..
flutter build ios --release

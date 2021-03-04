#!/bin/sh -ve
flutter config --enable-macos-desktop
flutter clean
flutter pub get
cd macos
pod install
pod update
cd ..
flutter build macos --release

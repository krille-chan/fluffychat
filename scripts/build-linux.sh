#!/bin/sh -ve
flutter channel dev
flutter upgrade
flutter config --enable-linux-desktop
echo "dependency_overrides:\n  intl: 0.17.0-nullsafety.2" >> pubspec.yaml
flutter clean
flutter pub get
flutter build linux --release -v

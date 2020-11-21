#!/usr/bin/env bash
flutter channel dev
flutter upgrade
flutter config --enable-linux-desktop
flutter clean
flutter pub get
flutter build linux --release -v
#!/usr/bin/env bash
flutter channel beta
flutter upgrade
flutter config --enable-web
/bin/bash ./scripts/prepare-web.sh
flutter clean
flutter pub get
flutter build web --release --verbose
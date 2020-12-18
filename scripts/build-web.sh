#!/bin/sh -ve
#flutter channel beta
#flutter upgrade
flutter config --enable-web
flutter clean
flutter pub get
flutter build web --release --verbose

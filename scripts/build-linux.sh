#!/bin/sh -ve
yes | flutter downgrade 1.26.0-12.0.pre
flutter config --enable-linux-desktop
flutter clean
flutter pub get
flutter build linux --release -v

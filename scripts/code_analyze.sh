#!/bin/sh -ve
flutter format lib/ test/ --set-exit-if-changed
flutter analyze
git apply ./scripts/enable-android-google-services.patch --check

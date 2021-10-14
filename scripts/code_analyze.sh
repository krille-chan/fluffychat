#!/bin/sh -ve
git apply ./scripts/enable-android-google-services.patch
flutter format lib/ test/ --set-exit-if-changed
flutter analyze

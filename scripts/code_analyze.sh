#!/bin/sh -ve
git apply ./scripts/enable-android-google-services.patch
flutter format lib/ test/ --set-exit-if-changed
flutter analyze
flutter pub run dart_code_metrics:metrics lib -r gitlab > code-quality-report.json || true
#!/bin/sh -ve
flutter pub get
flutter pub run import_sorter:main --no-comments --exit-if-changed
flutter format lib/ test/ --set-exit-if-changed
git apply ./scripts/enable-android-google-services.patch
flutter pub get
flutter analyze
flutter pub run dart_code_metrics:metrics lib -r gitlab > code-quality-report.json || true
#!/bin/sh -ve
flutter config --enable-web
flutter clean
flutter pub get
flutter build web --release --verbose --source-maps --dart-define=SENTRY_RELEASE=$CI_COMMIT_SHA

#!/bin/sh -ve
flutter config --enable-web
flutter clean
flutter pub get
flutter build web --dart-define=FLUTTER_WEB_CANVASKIT_URL=canvaskit/ --source-maps --base-href "/client/"
# flutter build web --release --verbose --source-maps --dart-define=SENTRY_RELEASE=$CI_COMMIT_SHA

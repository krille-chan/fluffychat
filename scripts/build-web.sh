#!/bin/sh -ve
flutter config --enable-web
flutter clean
flutter pub get
flutter build web --dart-define=FLUTTER_WEB_CANVASKIT_URL=canvaskit/ --profile --source-maps
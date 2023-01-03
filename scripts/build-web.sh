#!/bin/sh -ve
flutter config --enable-web
flutter clean
flutter pub get
flutter build web --release --verbose --source-maps
# bug of the Flutter engine
chmod +r -R build/web
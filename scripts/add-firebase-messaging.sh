#!/usr/bin/env bash

flutter pub add fcm_shared_isolate
flutter pub get

if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' 's,//<GOOGLE_SERVICES>,,g' lib/utils/background_push.dart
else
  sed -i 's,//<GOOGLE_SERVICES>,,g' lib/utils/background_push.dart
fi
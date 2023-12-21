#!/usr/bin/env bash

flutter pub add firebase_core
flutter pub add firebase_messaging
flutter pub get

if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' 's,//<GOOGLE_SERVICES>,,g' lib/main.dart
  sed -i '' 's,//<GOOGLE_SERVICES>,,g' lib/utils/background_push.dart
  sed -i '' -e 's,^/\*,,' -e 's,\*/$,,' android/app/src/main/kotlin/chat/fluffy/fluffychat/FcmPushService.kt
else
  sed -i 's,//<GOOGLE_SERVICES>,,g' lib/main.dart
  sed -i 's,//<GOOGLE_SERVICES>,,g' lib/utils/background_push.dart
  sed -i -e 's,^/\*,,' -e 's,\*/$,,' android/app/src/main/kotlin/chat/fluffy/fluffychat/FcmPushService.kt
fi

#!/usr/bin/env bash
sed -i 's/#<GOOGLE_SERVICES>//g' pubspec.yaml
sed -i 's,//<GOOGLE_SERVICES>,,g' android/build.gradle
sed -i 's,//<GOOGLE_SERVICES>,,g' android/app/build.gradle
sed -i 's,//<GOOGLE_SERVICES>,,g' lib/main.dart
sed -i 's,//<GOOGLE_SERVICES>,,g' lib/utils/background_push.dart
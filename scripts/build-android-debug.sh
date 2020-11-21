#!/usr/bin/env bash
flutter channel stable
flutter upgrade
truncate -s $(head -n -2 android/app/build.gradle | wc -c) android/app/build.gradle
flutter build apk --debug -v
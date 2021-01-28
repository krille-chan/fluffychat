#!/usr/bin/env bash
flutter channel stable
flutter upgrade
rm -rf android/.gradle
flutter build apk --debug -v

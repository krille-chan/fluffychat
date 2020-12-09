#!/usr/bin/env bash -v
flutter channel stable
flutter upgrade
flutter build apk --debug -v

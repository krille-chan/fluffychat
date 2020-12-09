#!/usr/bin/env bash -ve
flutter channel stable
flutter upgrade
flutter build apk --debug -v

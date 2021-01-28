#!/usr/bin/env bash
flutter channel stable
flutter upgrade
flutter build apk --debug -v

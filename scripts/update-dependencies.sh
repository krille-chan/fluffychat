#!/bin/sh -ve
flutter pub upgrade --major-versions
flutter pub get
dart fix --apply
flutter format lib test
flutter pub run import_sorter:main --no-comments
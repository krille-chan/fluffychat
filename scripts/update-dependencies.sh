#!/bin/sh -ve
flutter pub get
flutter pub pub run dapackages:dapackages.dart ./pubspec.yaml
flutter pub get
dart fix --apply

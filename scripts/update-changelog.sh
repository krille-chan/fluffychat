#!/usr/bin/env bash
flutter pub global activate changelog
export PATH="$PATH":"$HOME/development/flutter/.pub-cache/bin"
changelog -c
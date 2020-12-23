#!/bin/sh -ve
flutter format lib/ test/ --set-exit-if-changed
flutter analyze

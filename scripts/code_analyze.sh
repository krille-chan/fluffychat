#!/bin/sh -ve
flutter format lib/ test/ test_driver/ --set-exit-if-changed
flutter analyze

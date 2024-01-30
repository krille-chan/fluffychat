#!/bin/sh -ve
rm -rf assets/js/package

OLM_VERSION=$(cat pubspec.yaml | yq .dependencies.flutter_olm)
DOWNLOAD_PATH="https://github.com/famedly/olm/releases/download/v$OLM_VERSION/olm.zip"

cd assets/js/ && curl -L $DOWNLOAD_PATH > olm.zip && cd ../../
cd assets/js/ && unzip olm.zip && cd ../../
cd assets/js/ && rm olm.zip && cd ../../
cd assets/js/ && mv javascript package && cd ../../


# e2ee worker for livekit.
cd web
git clone https://github.com/flutter-webrtc/dart-webrtc.git -b e2ee/improvements
cd dart-webrtc
dart pub get
dart compile js lib/src/e2ee.worker/e2ee.worker.dart -o ../e2ee.worker.dart.js -m
cd .. && rm -rf dart-webrtc
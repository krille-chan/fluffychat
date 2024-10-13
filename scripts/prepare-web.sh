#!/bin/sh -ve
OLM_VERSION=$(cat pubspec.yaml | yq .dependencies.flutter_olm | tr -d '"^~' )
DOWNLOAD_PATH="https://github.com/famedly/olm/releases/download/v${OLM_VERSION}/olm.zip"

mkdir -p assets/js && cd assets/js
test -d package && rm -r package || echo "nothing to clear!"

curl -OLSs $DOWNLOAD_PATH
unzip olm.zip
rm olm.zip
mv javascript package

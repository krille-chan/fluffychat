#!/bin/sh -ve
ASSETS_DIR=assets/js
if [ -d "$ASSETS_DIR/package" ]; then
    rm -r "$ASSETS_DIR/package"
fi

OLM_VERSION=$(cat pubspec.yaml | yq -r .dependencies.flutter_olm )
DOWNLOAD_URL="https://github.com/famedly/olm/releases/download/v$OLM_VERSION/olm.zip"
DOWNLOAD_PATH="/tmp/fluffychat-build-olm.zip"

mkdir -p "$ASSETS_DIR"
echo Fetching $DOWNLOAD_URL
curl -L "$DOWNLOAD_URL" -o "$DOWNLOAD_PATH"

if [ $? = 0 ]; then
    unzip "$DOWNLOAD_PATH" -d "$ASSETS_DIR"
    rm "$DOWNLOAD_PATH" 
    mv "$ASSETS_DIR/javascript" "$ASSETS_DIR/package"
else
    echo Failed to download release archive
fi

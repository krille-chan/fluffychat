#!/bin/sh -ve

# Build a release version of the app for a platform and upload symbols
OUTPUT_FOLDER_WEB=./build/web/
SENTRY_RELEASE=$CI_COMMIT_SHA
SENTRY_PROJECT="client"
SENTRY_ORG="pangea-chat"

echo "[run] Uploading sourcemaps for $SENTRY_RELEASE"
sentry-cli releases new $SENTRY_RELEASE
sentry-cli releases set-commits $CI_COMMIT_SHA --auto
sentry-cli releases files $SENTRY_RELEASE upload-sourcemaps . \
    --ext dart \
    --rewrite

(cd $OUTPUT_FOLDER_WEB
sentry-cli releases files $SENTRY_RELEASE upload-sourcemaps . \
    --ext map \
    --ext js \
    --rewrite)

sentry-cli releases finalize $SENTRY_RELEASE

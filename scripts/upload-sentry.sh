#!/bin/sh -ve

# Build a release version of the app for a platform and upload symbols
export OUTPUT_FOLDER_WEB=./build/web/
export SENTRY_RELEASE=$CI_COMMIT_SHA
export SENTRY_PROJECT="${SENTRY_ORG:-client}"
export SENTRY_ORG="${SENTRY_ORG:-pangea-chat}"

echo "[run] Uploading sourcemaps for $SENTRY_RELEASE"
echo "[run] $SENTRY_PROJECT @ $SENTRY_ORG / $OUTPUT_FOLDER_WEB"
sentry-cli releases new $SENTRY_RELEASE --org $SENTRY_ORG
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

#!/usr/bin/env bash

GITLAB_PROJECT_ID="16112282"

mkdir fdroid/repo
mkdir repo

git fetch

cd fdroid

# building nightly repo

cp config.nightly.py config.py

PIPELINES="$(curl https://gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}/pipelines\?ref=main\&status=success\&order_by=updated_at | jq '.[].id' | head -n3)"

cp ../build/app/outputs/apk/debug/app-debug.apk repo/fluffychat-latest.apk

for PIPELINE in $PIPELINES
do
  JOB="$(curl https://gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}/pipelines/$PIPELINE/jobs | jq -r '.[] | select(.name == "build_android_apk").id')"
  if [ -n $JOB ]; then
    URI="https://gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}/jobs/$JOB/artifacts/build/android/app-release.apk"
    FILENAME="fluffychat-$PIPELINE.apk"
    echo "Downloading $FILENAME from $URI ..."
    wget --output-document="$FILENAME" "$URI"
    mv "$FILENAME" repo
  fi
done

fdroid update --rename-apks
mkdir /fdroid && fdroid deploy
rm -rf /fdroid
cd .. && mkdir public && mv -v /fdroid repo/nightly


# building stable + RC repo

mkdir /fdroid

cd fdroid
rm -f repo/*.apk

cp config.stable.py config.py

PIPELINES="$(curl https://gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}/pipelines\?scope=tags\&status=success\&order_by=updated_at | jq '.[].id' | head -n3)"

for PIPELINE in $PIPELINES
do
  JOB="$(curl https://gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}/pipelines/$PIPELINE/jobs | jq -r '.[] | select(.name == "build_android_apk").id')"
  if [ -n $JOB ]; then
    URI="https://gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}/jobs/$JOB/artifacts/build/android/app-release.apk"
    FILENAME="fluffychat-$PIPELINE.apk"
    echo "Downloading $FILENAME from $URI ..."
    wget --output-document="$FILENAME" "$URI"
    mv "$FILENAME" repo
  fi
done

fdroid update --rename-apks
mkdir /fdroid && fdroid deploy
rm -rf /fdroid/archive
cd .. && mv -v /fdroid repo/stable

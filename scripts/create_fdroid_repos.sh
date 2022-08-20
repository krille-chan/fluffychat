#!/usr/bin/env bash

GITLAB_PROJECT_ID="16112282"

# repo directory for build
mkdir fdroid/repo
# ... and for deployment
mkdir repo

git fetch

# building nightly repo

cd fdroid

cp config.nightly.py config.py

PIPELINES="$(curl https://gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}/pipelines\?ref=main\&status=success\&order_by=updated_at | jq '.[].id' | head -n3)"

cp ../build/android/app-release.apk repo/fluffychat-latest.apk

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
cd .. && mv -v /fdroid repo/nightly

# building stable + RC repo

rm -rf /fdroid fdroid/repo

mkdir fdroid/repo

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

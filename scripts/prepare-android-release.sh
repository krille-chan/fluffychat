#!/usr/bin/env bash
/bin/bash ./scripts/prepare-android-release.sh
cd android && echo $FDROID_KEY | base64 --decode --ignore-garbage > key.jks && cd ..
cd android && echo "storePassword=${FDROID_KEY_PASS}" >> key.properties && cd ..
cd android && echo "keyPassword=${FDROID_KEY_PASS}" >> key.properties && cd ..
cd android && echo "keyAlias=key" >> key.properties && cd ..
cd android && echo "storeFile=../key.jks" >> key.properties && cd ..
cd android/app && echo $GOOGLE_SERVICES >> google-services.json && cd ../..
#!/usr/bin/env bash

cp -r android/fastlane fdroid/metadata/chat.fluffy.fluffychat
cd fdroid
echo $FDROID_KEY | base64 --decode --ignore-garbage > key.jks
echo $FDROID_NIGHTLY_KEY | base64 --decode --ignore-garbage > key.nightly.jks
echo "keypass=\"${FDROID_KEY_PASS}\"" >> config.stable.py
echo "keystorepass=\"${FDROID_KEY_PASS}\"" >> config.stable.py
echo "keypass=\"${FDROID_NIGHTLY_KEY_PASS}\"" >> config.nightly.py
echo "keystorepass=\"${FDROID_NIGHTLY_KEY_PASS}\"" >> config.nightly.py
chmod 600 config.stable.py key.jks config.nightly.py key.nightly.jks
cd ..

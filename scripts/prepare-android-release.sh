#!/usr/bin/env bash
cd android
echo $PLAY_STORE_UPLOAD_KEY | base64 --decode > key.jks
echo "storePassword=${PLAY_STORE_KEYSTORE_STORE_PASSWORD}" >> key.properties
echo "keyPassword=${PLAY_STORE_KEYSTORE_KEY_PASSWORD}" >> key.properties
echo "keyAlias=${PLAY_STORE_KEYSTORE_KEY_ALIAS}" >> key.properties
echo "storeFile=../key.jks" >> key.properties
echo $PLAY_STORE_CONFIG_JSON | base64 --decode > keys.json
ls | grep key
bundle install
bundle update fastlane
bundle exec fastlane set_build_code_internal
cd ..

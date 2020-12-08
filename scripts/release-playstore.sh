#!/bin/sh -ve
cd android
bundle install
bundle update fastlane
echo $PLAYSTORE_DEPLOY_KEY >> keys.json
bundle exec fastlane deploy_release
cd ..

#!/bin/sh -ve
RELEASE_TYPE=$(echo $CI_COMMIT_TAG | grep -oE "[a-z]+")
cd android
if [ "$RELEASE_TYPE" = "rc" ]; then
    bundle exec fastlane deploy_candidate
else
    bundle exec fastlane deploy_release
fi
cd ..

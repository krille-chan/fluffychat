#!/bin/sh -ve
cd android
if [RELEASE_TYPE = "rc"]; then
    bundle exec fastlane deploy_candidate
else
    bundle exec fastlane deploy_release
fi
cd ..

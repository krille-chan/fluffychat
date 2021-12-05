#!/bin/sh -ve
RELEASE_TYPE=$(echo $CI_COMMIT_TAG | grep -oE "[a-z]+")
echo $SNAPCRAFT_LOGIN_FILE | snapcraft login --with -
snapcraft
if [ "$RELEASE_TYPE" = "rc" ]; then
    snapcraft upload --release=candidate *.snap
else
    snapcraft upload --release=stable *.snap
fi
snapcraft logout

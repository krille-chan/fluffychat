#!/bin/sh -ve
echo $SNAPCRAFT_LOGIN_FILE | snapcraft login --with -
snapcraft remote-build --launchpad-accept-public-upload --status
snapcraft upload --release=edge *.snap
snapcraft logout

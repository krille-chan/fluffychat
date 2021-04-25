#!/bin/sh -ve
echo $SNAPCRAFT_LOGIN_FILE | base64 --decode --ignore-garbage > snapcraft.login
snapcraft login --with snapcraft.login
snapcraft remote-build --launchpad-accept-public-upload
snapcraft push --release=edge *.snap
snapcraft logout

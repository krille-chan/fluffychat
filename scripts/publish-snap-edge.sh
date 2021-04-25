#!/bin/sh -ve
snapcraft remote-build --launchpad-accept-public-upload
echo $SNAPCRAFT_LOGIN_FILE | base64 --decode --ignore-garbage > snapcraft.login
snapcraft login --with snapcraft.login
snapcraft push --release=edge *.snap
snapcraft logout

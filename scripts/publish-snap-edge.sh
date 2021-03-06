#!/bin/sh -ve
snapcraft
echo $SNAPCRAFT_LOGIN_FILE | base64 --decode --ignore-garbage > snapcraft.login
snapcraft login --with snapcraft.login
snapcraft push --release=edge *.snap
snapcraft logout

#!/bin/sh -ve
echo $SNAPCRAFT_LOGIN_FILE | base64 --decode --ignore-garbage > snapcraft.login
snapcraft login --with snapcraft.login
snapcraft
snapcraft upload --release=stable *.snap
snapcraft logout

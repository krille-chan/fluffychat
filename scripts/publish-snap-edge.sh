#!/bin/sh -ve
echo $SNAPCRAFT_LOGIN_FILE | snapcraft login --with -
snapcraft
snapcraft upload --release=edge *.snap
snapcraft logout

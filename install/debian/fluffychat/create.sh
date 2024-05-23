#!/bin/bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
pushd "$SCRIPT_DIR" > /dev/null

pushd ../../.. > /dev/null
flutter clean
flutter build linux --release
popd > /dev/null

WORKDIR="/tmp/custom-packages/$(uuid)"
PACKDIR="$WORKDIR/package"
PROGDIR="$PACKDIR/opt/fluffychat"
CTRLDIR="$PACKDIR/DEBIAN"

mkdir -p "$PROGDIR"
mkdir -p "$CTRLDIR"

cp -a control "$CTRLDIR/"

cp -ar ../../../build/linux/x64/release/bundle/* "$PROGDIR/"
cp -ar usr "$PACKDIR/"
mkdir -p "$PACKDIR/usr/share/icons/hicolor/scalable/apps"
cp -ar ../../../assets/logo.svg "$PACKDIR/usr/share/icons/hicolor/scalable/apps/im.fluffychat.svg"

DATETIME="$(find "$PACKDIR" -type f -printf '%TY%Tm%Td%TH%TM\n' | sort | tail -n 1)"

chown -R user:user "$PACKDIR"
find "$PACKDIR" -type d | xargs -I '{}' chmod 0755 {}
find "$PACKDIR" -type f | xargs -I '{}' chmod 0644 {}
chmod a+x "$PROGDIR/fluffychat"
find "$PACKDIR/usr/bin" -type f | xargs -I{} chmod a+x {}

PACKAGE_VERSION="$(grep 'version: ' ../../../pubspec.yaml | sed 's/version: \(.*\)+[0-9]\+/\1/')"
sed -i "s/{{VERSION}}/$PACKAGE_VERSION/g" "$CTRLDIR/control"

PACKAGE_NAME="$(cat control | head -n 1 | cut -d ' ' -f 2)"
PACKAGE_FULLNAME="${PACKAGE_NAME}_${PACKAGE_VERSION}_amd64"
find "$PACKDIR" -exec touch -h -t $DATETIME {} \;
touch -t $DATETIME "$PACKDIR"
pushd "$WORKDIR" > /dev/null
dpkg-deb --build --root-owner-group package
ar -x package.deb 2> /dev/null
rm package.deb
ar -qD package.deb debian-binary control.tar.xz data.tar.xz 2> /dev/null
popd > /dev/null
cp "$WORKDIR/package.deb" "$1/$PACKAGE_FULLNAME.deb"
touch -t $DATETIME "$1/$PACKAGE_FULLNAME.deb"
rm -rf "$WORKDIR"

popd > /dev/null


#!/usr/bin/env bash

# generate a temporary signing key adn apply its configuration
cd android
KEYFILE="$(pwd)/key.jks"
echo "Generating signing configuration with $KEYFILE..."
keytool -genkey -keyalg RSA -alias key -keysize 4096 -dname "cn=FluffyChat CI, ou=Head of bad integration tests, o=FluffyChat HQ, c=TLH" -keypass Tawkie -storepass Tawkie -validity 1 -keystore "$KEYFILE" -storetype "pkcs12"
echo "storePassword=TAWKIE" >> key.properties
echo "keyPassword=TAWKIE" >> key.properties
echo "keyAlias=key" >> key.properties
echo "storeFile=$KEYFILE" >> key.properties
ls | grep key
cd ..

# build release mode APK
flutter pub get
flutter build apk --release

# install and launch APK
flutter install
adb shell am start -n fr.tawkie.app/fr.tawkie.app.MainActivity

sleep 5

# check whether FluffyChat runs
adb shell ps | awk '{print $9}' | grep fr.tawkie.app

read -n 1 -s -r -p "Appuyez sur n'importe quelle touche pour quitter..."
# FluffyChat AppImage

FluffyChat is provided as AppImage too. To Download, visit fluffychat.im.

## Building

- Ensure you install `appimagetool`

```shell
flutter build linux

# copy binaries to appimage dir
cp -r build/linux/{x64,arm64}/release/bundle appimage/FluffyChat.AppDir
cd appimage

# prepare AppImage files
cp FluffyChat.desktop FluffyChat.AppDir/
mkdir -p FluffyChat.AppDir/usr/share/icons
cp ../assets/logo.svg FluffyChat.AppDir/fluffychat.svg
cp AppRun FluffyChat.AppDir

# build the AppImage
appimagetool FluffyChat.AppDir
```

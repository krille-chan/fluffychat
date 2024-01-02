# Tawkie AppImage

FluffyChat is provided as AppImage too. To Download, visit fluffychat.im.

## Building

- Ensure you install `appimagetool`

```shell
flutter build linux

# copy binaries to appimage dir
cp -r build/linux/{x64,arm64}/release/bundle appimage/Tawkie.AppDir
cd appimage

# prepare AppImage files
cp Tawkie.desktop Tawkie.AppDir/
mkdir -p Tawkie.AppDir/usr/share/icons
cp ../assets/logo.svg Tawkie.AppDir/Tawkie.svg
cp AppRun Tawkie.AppDir

# build the AppImage
appimagetool Tawkie.AppDir
```

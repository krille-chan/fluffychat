# Hermes AppImage

Hermes is provided as AppImage too. To Download, visit hermes.im.

## Building

- Ensure you install `appimagetool`

```shell
flutter build linux

# copy binaries to appimage dir
cp -r build/linux/{x64,arm64}/release/bundle appimage/Hermes.AppDir
cd appimage

# prepare AppImage files
cp Hermes.desktop Hermes.AppDir/
mkdir -p Hermes.AppDir/usr/share/icons
cp ../assets/logo.svg Hermes.AppDir/hermes.svg
cp AppRun Hermes.AppDir

# build the AppImage
appimagetool Hermes.AppDir
```

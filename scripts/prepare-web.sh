#!/bin/sh -ve

version=$(yq ".dependencies.flutter_vodozemac" < pubspec.yaml)
version=$(expr "$version" : '\^*\(.*\)')
git clone https://github.com/famedly/dart-vodozemac.git -b ${version} .vodozemac
cd .vodozemac
cargo install flutter_rust_bridge_codegen
flutter_rust_bridge_codegen build-web --dart-root dart --rust-root $(readlink -f rust) --release
cd ..
rm -f ./assets/vodozemac/vodozemac_bindings_dart*
mv .vodozemac/dart/web/pkg/vodozemac_bindings_dart* ./assets/vodozemac/
rm -rf .vodozemac

# Add native imaging:
cd web/
curl -L 'https://github.com/famedly/dart_native_imaging/releases/download/v0.2.1/native_imaging.zip' > native_imaging.zip # make sure to sync version with pubspec.yaml
unzip native_imaging.zip
mv js/* .
rmdir js
rm native_imaging.zip
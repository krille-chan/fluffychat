#!/bin/sh -ve

git clone https://github.com/famedly/dart-vodozemac.git .vodozemac
cd .vodozemac
cargo install flutter_rust_bridge_codegen
flutter_rust_bridge_codegen build-web --dart-root dart --rust-root $(readlink -f rust) --release
cd ..
mv .vodozemac/dart/web/pkg ./web/
rm -rf .vodozemac

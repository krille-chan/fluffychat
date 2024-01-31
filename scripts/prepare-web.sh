#!/bin/sh -ve
rm -r assets/js || true
mkdir assets/js
cd web/
# curl -L $(curl -s 'https://api.github.com/repos/famedly/olm/releases' | jq -r '.[0] | .assets | .[0] | .browser_download_url') > olm.zip
curl -L 'https://github.com/famedly/olm/releases/download/v1.3.2/olm.zip' > olm.zip # make sure to sync version with pubspec.yaml
unzip olm.zip
rm olm.zip

# extract olm version and encode it in the files to cache bust
# The first line is a link to source code including tag.
# We extract the version number from the tag by only printing the line matching the sed expression (-n).
# We only print the first capture group, which is 3 digit groups separated by dots.
# macOS sed does not have the + quantifier, so for the first group we emulate it by matching the first digit explicitly.
olm_version=$(sed -n 's,// @source: .*\([[:digit:]][[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*\),\1,p' javascript/olm.js)
sed -i'.bak' "s/olm.js.*\"/olm.js?v=${olm_version}\"/" index.html
sed -i'.bak' "s/olm.wasm/olm.wasm?v=${olm_version}/" javascript/olm.js
rm index.html.bak
rm javascript/olm.js.bak

mv javascript/* .
rmdir javascript

# curl -L $(curl -s 'https://api.github.com/repos/famedly/dart_native_imaging/releases' | jq -r '.[0] | .assets | .[0] | .browser_download_url') > native_imaging.zip
curl -L 'https://github.com/famedly/dart_native_imaging/releases/download/v0.1.1/native_imaging.zip' > native_imaging.zip # make sure to sync version with pubspec.yaml
unzip native_imaging.zip
mv js/* .
rmdir js
rm native_imaging.zip


git clone https://github.com/flutter-webrtc/dart-webrtc.git -b e2ee/improvements
cd dart-webrtc
dart pub get
dart compile js lib/src/e2ee.worker/e2ee.worker.dart -o ../e2ee.worker.dart.js -m
cd .. && rm -rf dart-webrtc
#!/bin/sh -ve
rm -r assets/js/package
cd assets/js/ && curl -L $(curl -s 'https://api.github.com/repos/famedly/olm/releases' | jq -r '.[0] | .assets | .[0] | .browser_download_url') > olm.zip && cd ../../
cd assets/js/ && unzip olm.zip && cd ../../
cd assets/js/ && rm olm.zip && cd ../../
cd assets/js/ && mv javascript package && cd ../../

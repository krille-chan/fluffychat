#!/bin/sh -ve
rm -r assets/js/package
cd assets/js/ && curl -L 'https://gitlab.com/famedly/company/frontend/libraries/olm/-/jobs/artifacts/master/download?job=build:js' > olm.zip && cd ../../
cd assets/js/ && unzip olm.zip && cd ../../
cd assets/js/ && rm olm.zip && cd ../../
cd assets/js/ && mv javascript package && cd ../../

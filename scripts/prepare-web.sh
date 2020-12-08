#!/bin/sh -ve
rm -r assets/js/package
cd assets/js/ && curl -L 'https://gitlab.com/famedly/libraries/olm/-/jobs/artifacts/master/download?job=build_js' > olm.zip && cd ../../
cd assets/js/ && unzip olm.zip && cd ../../
cd assets/js/ && rm olm.zip && cd ../../
cd assets/js/ && mv javascript package && cd ../../
cd web/ && rm sql-wasm.js sql-wasm.wasm && cd ../
cd web/ && curl -L 'https://github.com/sql-js/sql.js/releases/latest/download/sqljs-wasm.zip' > sqljs-wasm.zip && cd ../
cd web/ && unzip sqljs-wasm.zip && cd ../
cd web/ && rm sqljs-wasm.zip && cd ../

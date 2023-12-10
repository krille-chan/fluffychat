#!/usr/bin/env bash

git clone https://gitlab.matrix.org/matrix-org/olm.git -b 3.2.12 
cd olm
cmake . -Bbuild -DCMAKE_TOOLCHAIN_FILE=Windows64.cmake
cmake --build build
cd ..

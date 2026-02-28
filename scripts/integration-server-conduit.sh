#!/usr/bin/env bash
docker run -d \
  -e CONDUIT_SERVER_NAME="localhost" \
  -e CONDUIT_PORT="8008" \
  -e CONDUIT_DATABASE_BACKEND="rocksdb" \
  -e CONDUIT_ALLOW_REGISTRATION=true \
  -e CONDUIT_ALLOW_FEDERATION=true \
  -e CONDUIT_MAX_REQUEST_SIZE="20000000" \
  -e CONDUIT_TRUSTED_SERVERS="[\"conduit.rs\"]" \
  -e CONDUIT_MAX_CONCURRENT_REQUESTS="100" \
  -e CONDUIT_LOG="info,rocket=off,_=off,sled=off" \
  --name conduit -p 80:8008 matrixconduit/matrix-conduit:latest

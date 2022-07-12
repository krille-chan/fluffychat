#!/usr/bin/env bash
chown -R 991:991 integration_test/synapse
docker run -d --name synapse --user 991:991 --volume="$(pwd)/integration_test/synapse/data":/data:rw -p 8008:8008 matrixdotorg/synapse:latest
sleep 20
#!/usr/bin/env bash
docker run -d --name synapse --tmpfs /data \
    --volume="$(pwd)/integration_test/synapse/data/homeserver.yaml":/data/homeserver.yaml:rw \
    --volume="$(pwd)/integration_test/synapse/data/localhost.log.config":/data/localhost.log.config:rw \
    -p 80:80 matrixdotorg/synapse:latest

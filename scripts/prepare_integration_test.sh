#!/usr/bin/env bash

source integration_test/data/integration_users.env

docker rm -f synapse 2>/dev/null || true

docker run -d --name synapse --tmpfs /data \
    --volume="$(pwd)/integration_test/synapse/data/homeserver.yaml":/data/homeserver.yaml:rw \
    --volume="$(pwd)/integration_test/synapse/data/localhost.log.config":/data/localhost.log.config:rw \
    -p 80:80 matrixdotorg/synapse:latest

while ! curl -XGET "http://$HOMESERVER/_matrix/client/v3/login" >/dev/null 2>/dev/null; do
echo "Waiting for homeserver to be available... (GET http://$HOMESERVER/_matrix/client/v3/login)"
    sleep 2
done

echo "Homeserver is online!"

# create users
curl -fS --retry 3 -XPOST -d "{\"username\":\"$USER1_NAME\", \"password\":\"$USER1_PW\", \"inhibit_login\":true, \"auth\": {\"type\":\"m.login.dummy\"}}" "http://$HOMESERVER/_matrix/client/r0/register"
curl -fS --retry 3 -XPOST -d "{\"username\":\"$USER2_NAME\", \"password\":\"$USER2_PW\", \"inhibit_login\":true, \"auth\": {\"type\":\"m.login.dummy\"}}" "http://$HOMESERVER/_matrix/client/r0/register"

echo "Homeserver is ready! Please rerun this script every time before starting an integration test!"
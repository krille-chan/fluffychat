#!/usr/bin/env bash


while ! curl -XGET "http://localhost/_matrix/client/v3/login" >/dev/null 2>/dev/null; do
  echo "Waiting for homeserver to be available... (GET http://localhost/_matrix/client/v3/login)"
  sleep 2
done

# create users
curl -fS --retry 3 -XPOST -d "{\"username\":\"$USER1_NAME\", \"password\":\"$USER1_PW\", \"inhibit_login\":true, \"auth\": {\"type\":\"m.login.dummy\"}}" "http://localhost/_matrix/client/r0/register"
curl -fS --retry 3 -XPOST -d "{\"username\":\"$USER2_NAME\", \"password\":\"$USER2_PW\", \"inhibit_login\":true, \"auth\": {\"type\":\"m.login.dummy\"}}" "http://localhost/_matrix/client/r0/register"

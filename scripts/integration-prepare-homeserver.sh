#!/usr/bin/env bash

if [ -z $HOMESERVER ]; then
  echo "Please ensure HOMESERVER environment variable is set to the IP or hostname of the homeserver."
  exit 1
fi
if [ -z $USER1_NAME ]; then
  echo "Please ensure USER1_NAME environment variable is set to first user name."
  exit 1
fi
if [ -z $USER1_PW ]; then
  echo "Please ensure USER1_PW environment variable is set to first user password."
  exit 1
fi
if [ -z $USER2_NAME ]; then
  echo "Please ensure USER2_NAME environment variable is set to second user name."
  exit 1
fi
if [ -z $USER2_PW ]; then
  echo "Please ensure USER2_PW environment variable is set to second user password."
  exit 1
fi

echo "Waiting for homeserver to be available... (GET http://$HOMESERVER/_matrix/client/v3/login)"

while ! curl -XGET "http://$HOMESERVER/_matrix/client/v3/login" >/dev/null 2>/dev/null; do
  sleep 2
done

echo "Homeserver is up."

# create users

curl -fS --retry 3 -XPOST -d "{\"username\":\"$USER1_NAME\", \"password\":\"$USER1_PW\", \"inhibit_login\":true, \"auth\": {\"type\":\"m.login.dummy\"}}" "http://$HOMESERVER/_matrix/client/r0/register"
curl -fS --retry 3 -XPOST -d "{\"username\":\"$USER2_NAME\", \"password\":\"$USER2_PW\", \"inhibit_login\":true, \"auth\": {\"type\":\"m.login.dummy\"}}" "http://$HOMESERVER/_matrix/client/r0/register"

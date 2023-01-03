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

usertoken1=$(curl -fS --retry 3 "http://$HOMESERVER/_matrix/client/r0/login" -H "Content-Type: application/json" -d "{\"type\": \"m.login.password\", \"identifier\": {\"type\": \"m.id.user\",\"user\": \"$USER1_NAME\"},\"password\":\"$USER1_PW\"}" | jq -r '.access_token')
usertoken2=$(curl -fS --retry 3 "http://$HOMESERVER/_matrix/client/r0/login" -H "Content-Type: application/json" -d "{\"type\": \"m.login.password\", \"identifier\": {\"type\": \"m.id.user\",\"user\": \"$USER2_NAME\"},\"password\":\"$USER2_PW\"}" | jq -r '.access_token')


# get usernames' mxids
mxid1=$(curl -fS --retry 3 "http://$HOMESERVER/_matrix/client/r0/account/whoami" -H "Authorization: Bearer $usertoken1" | jq -r .user_id)
mxid2=$(curl -fS --retry 3 "http://$HOMESERVER/_matrix/client/r0/account/whoami" -H "Authorization: Bearer $usertoken2" | jq -r .user_id)

# setting the display name to username
curl -fS --retry 3 -XPUT -d "{\"displayname\":\"$USER1_NAME\"}" "http://$HOMESERVER/_matrix/client/v3/profile/$mxid1/displayname" -H "Authorization: Bearer $usertoken1"
curl -fS --retry 3 -XPUT -d "{\"displayname\":\"$USER2_NAME\"}" "http://$HOMESERVER/_matrix/client/v3/profile/$mxid2/displayname" -H "Authorization: Bearer $usertoken2"

echo "Set display names"

# create new room to invite user too
roomID=$(curl --retry 3 --silent --fail -XPOST -d "{\"name\":\"$USER2_NAME\", \"is_direct\": true}" "http://$HOMESERVER/_matrix/client/r0/createRoom?access_token=$usertoken2" | jq -r '.room_id')
echo "Created room '$roomID'"

# send message in created room
curl --retry 3 --fail --silent -XPOST -d '{"msgtype":"m.text", "body":"joined room successfully"}' "http://$HOMESERVER/_matrix/client/r0/rooms/$roomID/send/m.room.message?access_token=$usertoken2"
echo "Sent message"

curl -fS --retry 3 -XPOST -d "{\"user_id\":\"$mxid1\"}" "http://$HOMESERVER/_matrix/client/r0/rooms/$roomID/invite?access_token=$usertoken2"
echo "Invited $USER1_NAME"

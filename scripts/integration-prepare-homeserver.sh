#!/usr/bin/env bash
IP_ADDRESS="$(drill docker | grep -m 1 -P "\d+\.\d+\.\d+.\d+" | awk -F ' ' '{print $NF}')"

sed -i "s/10.0.2.2/$IP_ADDRESS/g" integration_test/users.dart

curl -XPOST -d '{"username":"alice", "password":"AliceInWonderland", "inhibit_login":true, "auth": {"type":"m.login.dummy"}}' "http://$IP_ADDRESS:8008/_matrix/client/r0/register"
curl -XPOST -d '{"username":"bob", "password":"JoWirSchaffenDas", "inhibit_login":true, "auth": {"type":"m.login.dummy"}}' "http://$IP_ADDRESS:8008/_matrix/client/r0/register"
curl -XPOST -d '{"username":"trudy", "password":"HaveIBeenPwned", "inhibit_login":true, "auth": {"type":"m.login.dummy"}}' "http://$IP_ADDRESS:8008/_matrix/client/r0/register"
---
applyTo: "**/.env,**/assets/.env*"
---

# Matrix Auth — Staging Test Tokens

How to obtain a Matrix access token for staging API testing (choreo endpoints, Synapse admin API, Playwright login, etc.).

## Credentials

Staging test credentials live in `client/.env`:

- `STAGING_TEST_EMAIL` — email address
- `STAGING_TEST_USER` — full Matrix user ID (e.g. `@wykuji:staging.pangea.chat`)
- `STAGING_TEST_PASSWORD` — password

Read these values from the file at runtime. **Never hardcode credentials in skills, scripts, or chat output.**

## Get a Matrix Access Token

```sh
curl -s -X POST 'https://matrix.staging.pangea.chat/_matrix/client/v3/login' \
  -H 'Content-Type: application/json' \
  -d '{
    "type": "m.login.password",
    "identifier": {"type": "m.id.user", "user": "<USERNAME_WITHOUT_@_OR_DOMAIN>"},
    "password": "<STAGING_TEST_PASSWORD>"
  }' | python3 -m json.tool
```

The response contains `access_token`, `user_id`, `device_id`, and `home_server`.

### Extracting the token programmatically

```sh
# Read creds from client/.env
STAGING_USER=$(grep STAGING_TEST_USER client/.env | sed 's/.*= *"//;s/".*//' | sed 's/@//;s/:.*//')
STAGING_PASS=$(grep STAGING_TEST_PASSWORD client/.env | sed 's/.*= *"//;s/".*//')

# Login and extract token
MATRIX_TOKEN=$(curl -s -X POST 'https://matrix.staging.pangea.chat/_matrix/client/v3/login' \
  -H 'Content-Type: application/json' \
  -d "{\"type\":\"m.login.password\",\"identifier\":{\"type\":\"m.id.user\",\"user\":\"$STAGING_USER\"},\"password\":\"$STAGING_PASS\"}" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")

echo "$MATRIX_TOKEN"
```

## Use the Token

### Choreo API

Choreo requires **both** the Matrix token and the API key (from `CHOREO_API_KEY` in `client/.env`):

```sh
curl -s 'https://api.staging.pangea.chat/choreo/<endpoint>' \
  -H "Authorization: Bearer $MATRIX_TOKEN" \
  -H 'api-key: <CHOREO_API_KEY>'
```

### Synapse Client-Server API

```sh
curl -s 'https://matrix.staging.pangea.chat/_matrix/client/v3/joined_rooms' \
  -H "Authorization: Bearer $MATRIX_TOKEN"
```

### Synapse Admin API

The test account is **not** a server admin. For admin endpoints, use the bot account or a real admin token.

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `M_FORBIDDEN` | Token expired or invalidated | Re-run the login curl to get a fresh token |
| `M_UNKNOWN_TOKEN` | Token from a different homeserver or old session | Confirm you're hitting `matrix.staging.pangea.chat` |
| `Could not validate Matrix token` from choreo | Missing `api-key` header | Add both `Authorization` and `api-key` headers |
| `M_USER_DEACTIVATED` | Test account was deactivated | Re-register or use a different test account |

#!/usr/bin/env bash
set -e

ENV_FILE="${1:-integration_test/data/integration_users.env}"

if [ ! -f "$ENV_FILE" ]; then
  echo "❌ .env file not found: $ENV_FILE"
  exit 1
fi

# read and export user data environment variables from file
set -o allexport
source "$ENV_FILE"
set +o allexport

echo "✅ Environment variables exported from $ENV_FILE"


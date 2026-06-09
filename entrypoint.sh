#!/bin/sh
set -e

: "${TALOS_DB_DSN:?TALOS_DB_DSN is required (e.g., sqlite:///var/lib/talos/talos.db)}"
: "${TALOS_CREDENTIALS_ISSUER:?TALOS_CREDENTIALS_ISSUER is required (e.g., https://talos.example.com)}"
: "${TALOS_SECRETS_HMAC_CURRENT:?TALOS_SECRETS_HMAC_CURRENT is required (generate with: openssl rand -base64 48 | tr -d '\n+/=' | cut -c1-64)}"

if [ ${#TALOS_SECRETS_HMAC_CURRENT} -lt 32 ]; then
	echo "ERROR: TALOS_SECRETS_HMAC_CURRENT must be at least 32 characters long"
	exit 1
fi

: "${PORT:=4420}"
: "${TALOS_HTTP_HOST:=0.0.0.0}"
: "${TALOS_METRICS_HOST:=0.0.0.0}"
: "${TALOS_METRICS_PORT:=4422}"
: "${TALOS_API_KEYS_PREFIX_CURRENT:=talos}"
: "${TALOS_API_KEYS_DEFAULT_TTL:=2160h}"
: "${TALOS_API_KEYS_MAX_TTL:=8760h}"
: "${TALOS_DERIVED_TOKENS_DEFAULT_TTL:=1h}"
: "${TALOS_MACAROON_PREFIX_CURRENT:=talos}"

echo "Configuration validation:"
echo "  TALOS_DB_DSN: ${TALOS_DB_DSN}"
echo "  TALOS_CREDENTIALS_ISSUER: ${TALOS_CREDENTIALS_ISSUER}"
echo "  PORT: ${PORT}"
echo "  TALOS_METRICS_PORT: ${TALOS_METRICS_PORT}"

envsubst < /etc/talos/talos.yml > /tmp/talos.yml

# Fix volume ownership in case Railway mounted it as root
chown -R ory:ory /var/lib/talos

echo "Running Talos migrations..."
su-exec ory talos migrate up --database "${TALOS_DB_DSN}"

echo "Starting Talos server..."
exec su-exec ory talos serve --config /tmp/talos.yml
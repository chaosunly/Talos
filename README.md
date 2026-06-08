# Ory Talos on Railway

This directory contains the configuration to deploy [Ory Talos](https://www.ory.com/docs/talos) on Railway.

## Overview

Ory Talos is Ory's API key management service. It handles issuing, verifying, importing, deriving,
and revoking API keys. This scaffold uses the open-source Talos image with SQLite for a simple
single-node deployment.

## What this service does

- Issues and verifies API keys
- Runs Talos database migrations on startup
- Exposes the Talos HTTP API on the Railway `PORT`
- Keeps the service configuration in a single generated YAML file

## Required environment variables

| Variable                     | Description                         | Example                            |
| ---------------------------- | ----------------------------------- | ---------------------------------- |
| `TALOS_DB_DSN`               | Database DSN                        | `sqlite:///var/lib/talos/talos.db` |
| `TALOS_CREDENTIALS_ISSUER`   | Issuer claim for derived tokens     | `https://talos.example.com`        |
| `TALOS_SECRETS_HMAC_CURRENT` | Current HMAC secret, 32+ characters | `generate-with-openssl-rand`       |

## Optional environment variables

| Variable             | Description                 | Default   |
| -------------------- | --------------------------- | --------- |
| `PORT`               | HTTP API listen port        | `4420`    |
| `TALOS_HTTP_HOST`    | HTTP bind address           | `0.0.0.0` |
| `TALOS_METRICS_PORT` | Health/metrics listen port  | `4422`    |
| `TALOS_METRICS_HOST` | Health/metrics bind address | `0.0.0.0` |

## Deployment notes

- Talos OSS is a single-node deployment and uses SQLite.
- Run this service on Railway with a persistent volume mounted at `/var/lib/talos`.
- If you need Postgres, MySQL, CockroachDB, multi-tenancy, or edge proxying, use the commercial edition.

## Files

- [Dockerfile](Dockerfile) - builds the Talos container image
- [talos.yml](talos.yml) - Talos config template rendered at startup
- [entrypoint.sh](entrypoint.sh) - validates env, runs migrations, and starts Talos

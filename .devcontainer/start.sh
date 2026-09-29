#!/usr/bin/env bash
# Builds the image from this repo and starts Moodle on the Codespace's public URL.
set -euo pipefail
cd "$(dirname "$0")/.."

if [ -n "${CODESPACE_NAME:-}" ]; then
  export SITE_URL="https://${CODESPACE_NAME}-80.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
  export SSLPROXY=true
fi

docker compose up -d --build
echo "Moodle: ${SITE_URL:-http://localhost} (first start takes a few minutes: docker compose logs -f moodle)"

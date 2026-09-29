#!/usr/bin/env bash
# Pulls the published images (or builds them if they are not published yet) and starts Moodle on the Codespace's public URL.
set -euo pipefail
cd "$(dirname "$0")/.."

if [ -n "${CODESPACE_NAME:-}" ]; then
  export SITE_URL="https://${CODESPACE_NAME}-80.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
  # The Codespaces proxy terminates HTTPS and rewrites the Host header, so Moodle
  # must trust it or it keeps redirecting to wwwroot (ERR_TOO_MANY_REDIRECTS).
  export SSLPROXY=true
  export REVERSEPROXY=true
fi

docker compose pull --quiet || true
docker compose up -d
echo "Moodle: ${SITE_URL:-http://localhost} (first start takes a few minutes: docker compose logs -f moodle)"

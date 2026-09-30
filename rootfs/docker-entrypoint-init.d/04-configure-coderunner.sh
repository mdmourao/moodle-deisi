#!/bin/sh
# Points CodeRunner at the Jobe server in JOBE_HOST (e.g. "jobe" in docker-compose).
set -e

if [ -z "${JOBE_HOST:-}" ]; then
  echo "JOBE_HOST not set, leaving CodeRunner settings unchanged."
  exit 0
fi

CFG="php -d max_input_vars=10000 /var/www/html/admin/cli/cfg.php"

$CFG --component=qtype_coderunner --name=jobe_host --set="$JOBE_HOST"
$CFG --component=qtype_coderunner --name=jobe_apikey --set="${JOBE_API_KEY:-}"
# Not set by default on fresh installs, which makes CodeRunner fail with
# "No sandboxes available for running code!".
$CFG --component=qtype_coderunner --name=jobesandbox_enabled --set=1

# Moodle blocks HTTP requests to private networks by default, which is where the
# Jobe container lives. Keep the other default blocks (localhost, cloud metadata).
$CFG --name=curlsecurityblockedhosts --set="$(printf '127.0.0.0/8\n0.0.0.0\nlocalhost\n169.254.169.254\n0000::1')"

echo "CodeRunner configured to use Jobe at $JOBE_HOST"

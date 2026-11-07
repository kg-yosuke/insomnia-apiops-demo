#!/usr/bin/env bash
# Wait until the gateway route returns 200.
# Covers config propagation after `deck gateway sync` and the cold start of
# Konnect Serverless Gateways (the first request after idling can take 10s+).
set -uo pipefail
url="$1"
for i in $(seq 1 12); do
  code=$(curl -s -o /dev/null -m 30 -w '%{http_code}' "$url")
  echo "attempt $i: HTTP $code"
  [ "$code" = "200" ] && exit 0
  sleep 5
done
echo "::error::Gateway did not return 200: $url"
exit 1

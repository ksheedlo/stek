#!/bin/bash

# Blueflood Metrics Service
# Usage: bf [METHOD] [ENDPOINT] [BODY]
#
# The Rackspace Metrics API is documented here:
#
#     https://developer.rackspace.com/docs/metrics/v2/developer-guide/#document-api-reference
#
# Rackspace Metrics is built on Blueflood, the open-source distributed metrics
# processing system. More information about Blueflood can be found at
# http://blueflood.io/.
#

bf() {
  stekUser=$(_stek_user)
  _stek_ensure_valid_catalog "$stekUser"
  authToken=$(_stek_token "$stekUser")
  serviceBase=$(_stek_service "$stekUser" "cloudMetrics")

  if [[ -n "$3" ]]
  then
    curl -H 'Content-Type: application/json' \
      -H 'Accept: application/json' \
      -H "User-Agent: $(uname -mnrs); $stekUser; stek 0.1.0" \
      -H "X-Auth-Token: $authToken" \
      "-X$1" "$serviceBase$2" -d "$3" \
      2>/dev/null | jq '.'
  else
    curl -H 'Content-Type: application/json' \
      -H 'Accept: application/json' \
      -H "User-Agent: $(uname -mnrs); $stekUser; stek 0.1.0" \
      -H "X-Auth-Token: $authToken" \
      "-X$1" "$serviceBase$2" \
      2>/dev/null | jq '.'
  fi
}


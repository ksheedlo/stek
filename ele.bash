#!/bin/bash

# Rackspace Monitoring Service
# Usage: ele [METHOD] [ENDPOINT] [BODY]
#
# Docs for the Rackspace Monitoring API can be found here:
#
#     https://developer.rackspace.com/docs/cloud-monitoring/v1/developer-guide/#document-api-reference
#

ele() {
  stekUser=$(_stek_user)
  _stek_ensure_valid_catalog "$stekUser"
  authToken=$(_stek_token "$stekUser")
  serviceBase=$(_stek_service "$stekUser" "cloudMonitoring")

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


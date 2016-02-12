#!/bin/bash

# Rackspace Monitoring Control API
# Usage: electl [METHOD] [ENDPOINT] [BODY]
#
# This plugin drives the control API for Rackspace Monitoring as defined
# in [Mimic](https://github.com/rackerlabs/mimic). It works when running
# stek against Mimic, but not against real Rackspace or Openstack services.
#

electl() {
  stekUser=$(_stek_user)
  _stek_ensure_valid_catalog "$stekUser"
  authToken=$(_stek_token "$stekUser")
  serviceBase=$(_stek_service "$stekUser" "cloudMonitoringControl")

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

#!/bin/bash

# Rackspace Cloud Queues / Openstack Zaqar Service
# Usage: cq [METHOD] [ENDPOINT] [BODY]
#
# This service is compatible with Rackspace Cloud Queues and the Openstack
# Zaqar REST API. More information about the API can be found here:
#
#     https://developer.rackspace.com/docs/cloud-queues/v1/developer-guide/
#

cq () {
  stekUser=$(_stek_user)
  _stek_ensure_valid_catalog "$stekUser"
  authToken=$(_stek_token "$stekUser")
  serviceBase=$(_stek_service "$stekUser" "cloudQueues")
  defaultClientId=$(_stek_cq_client_id "$stekUser")
  clientId="${CQ_CLIENT_ID:-$defaultClientId}"


  if [[ -n "$3" ]]
  then
    curl -H 'Content-Type: application/json' \
      -H 'Accept: application/json' \
      -H "User-Agent: $(uname -mnrs); $stekUser; stek 0.1.0" \
      -H "X-Auth-Token: $authToken" \
      -H "Client-ID: $clientId" \
      "-X$1" "$serviceBase$2" -d "$3" \
      2>/dev/null | jq '.'
  else
    curl -H 'Content-Type: application/json' \
      -H 'Accept: application/json' \
      -H "User-Agent: $(uname -mnrs); $stekUser; stek 0.1.0" \
      -H "X-Auth-Token: $authToken" \
      -H "Client-ID: $clientId" \
      "-X$1" "$serviceBase$2" \
      2>/dev/null | jq '.'
  fi
}


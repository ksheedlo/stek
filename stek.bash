#!/bin/bash

# Function: _stek_user
# Gets the current user.
# Returns: the current user's name, as a string.
#
_stek_user() {
  echo $(<"$HOME/.stek/user")
}

# Function: _stek_auth
# Authenticates to the Identity backend.
#
# Params:
#   1. Selected user
# Returns: Nothing
# Side effects: Writes a new service catalog to the user's stek directory
#
_stek_auth() {
  credsFile="$HOME/.stek/users/$1/creds.json"
  apiKey=$(jq -r '.api_key' <"$credsFile")
  username=$(jq -r '.username' <"$credsFile")
  if [[ "$username" == "null" ]]
  then
    username="$1"
  fi
  authUrl=$(jq -r '.auth_url' <"$credsFile")
  if [[ "$authUrl" == "null" ]]
  then
    authUrl="https://identity.api.rackspacecloud.com/v2.0"
  fi
  tenantId=$(jq -r '.tenant_id' <"$credsFile")
  tenantIdJson=""
  if [[ "$tenantId" != "null" ]]
  then
    tenantIdJson=', "tenantId": "'"$tenantId"'"'
  fi
  curl -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    -XPOST "$authUrl/tokens" \
    -d '{ "auth": { "RAX-KSKEY:apiKeyCredentials": { "username": "'"$username"'", "apiKey": "'"$apiKey"'" }'"$tenantIdJson"' } }' \
    2>/dev/null >"$HOME/.stek/users/$1/catalog.json"
}

# Function: _stek_ensure_valid_catalog
# Ensures that a catalog with a current access token is available.
#
# Params:
#   1. Selected user
# Returns: Nothing
# Side effects: May write a new service catalog to the user's stek directory
#
_stek_ensure_valid_catalog() {
  # If the user's catalog is not present or is expired, regenerate it.
  if [[ -e "$HOME/.stek/users/$1/catalog.json" ]]
  then
      [[ $(jq -r '.access.token.expires' <"$HOME/.stek/users/$1/catalog.json") \
         < $(TZ=UTC date +"%Y-%m-%dT%H:%M:%S") ]] && _stek_auth "$1" ;
  else
    _stek_auth "$1"
  fi
}

_stek_cq_client_id() {
  if [[ ! -e "$HOME/.stek/users/$1/cq_client_id" ]]
  then
    python -c 'import uuid; print(uuid.uuid4())' >"$HOME/.stek/users/$1/cq_client_id"
  fi
  echo $(<"$HOME/.stek/users/$1/cq_client_id")
}

# Function: _stek_service
# Gets the specified service by name.
#
# Params:
#   1. Selected user
#   2. Service name
# Returns: The base URL of the desired service.
#
_stek_service() {
  jq -r '.access.serviceCatalog | map(select(.name == "'"$2"'")) | .[].endpoints[0].publicURL' <"$HOME/.stek/users/$1/catalog.json"
}

# Function: _stek_token
# Gets the user's access token.
#
# Params:
#   1. Selected user
# Returns: The user's access token.
#
_stek_token() {
  jq -r '.access.token.id' <"$HOME/.stek/users/$1/catalog.json"
}

# Function: _stek_create_user
# Creates a new user.
#
# Params:
#   1. The user ID of the new user
# Returns: Nothing
# Side effects: A new user will be created.
#
_stek_create_user() {
  mkdir -p "$HOME/.stek/users/$1"
  read -p "Username [$1]: " input
  username="${input:-$1}"
  read -p "API Key: " apiKey
  read -p "Tenant ID (optional): " tenantId
  tenantIdJson=""
  if [[ -n "$tenantId" ]]
  then
    tenantIdJson=',"tenant_id":"'"$tenantId"'"'
  fi
  read -p "Auth URL [https://identity.api.rackspacecloud.com/v2.0]: " input
  authUrl="${input:-https://identity.api.rackspacecloud.com/v2.0}"
  echo '{"username":"'"$username"'","api_key":"'"$apiKey"'","auth_url":"'"$authUrl"'"'"$tenantIdJson"'}' \
    >"$HOME/.stek/users/$1/creds.json"
}

# Function: _stek_set_user
# Sets the current user.
#
# Params:
#   1. The user ID of the user to start using.
# Returns: Nothing
# Side effects: The user will be set.
#
_stek_set_user() {
  if [[ -e "$HOME/.stek/users/$1" ]]
  then
    echo "$1" >"$HOME/.stek/user"
    return 0
  else
    echo "Unknown user: $1"
    return 1
  fi
}

_stek_green() {
  printf '\E[32;40m'
  echo "$1"
  tput sgr0
}

_stek_list_users() {
  currentUser=$(_stek_user)
  for user in $HOME/.stek/users/*; do
    baseUser=$(basename "$user")
    if [[ "$currentUser" == "$baseUser" ]]
    then
      printf "* "
      _stek_green "$baseUser"
    else
      echo "  $baseUser"
    fi
  done
}

stek() {
  case "$1" in
    "user")
      if [[ -z "$2" ]]
      then
        _stek_user
      else
        _stek_set_user "$2"
      fi
      ;;
    "users")
      _stek_list_users
      ;;
    "new")
      _stek_create_user "$2"
      ;;
  esac
}

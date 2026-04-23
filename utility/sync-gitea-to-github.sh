#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=.env
source "$SCRIPT_DIR/.env"

for repo in $(curl -s -H "Authorization: token $GITEA_TOKEN" \
    "$GITEA_URL/api/v1/repos/search?limit=100" |
  jq -r '.data[] | select(.owner.login == "'"$GITEA_USER"'") | .name'); do
  echo "Syncing $repo..."
  curl -s -X POST \
    -H "Authorization: token $GITEA_TOKEN" \
    "$GITEA_URL/api/v1/repos/$GITEA_USER/$repo/push_mirrors-sync"
done

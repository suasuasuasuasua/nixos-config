#!/usr/bin/env bash
# Set up GitHub push mirrors for all Gitea repositories.
# Gitea is the source of truth; GitHub repos are created as mirrors.
# Usage: ./setup-gitea-github-mirrors.sh [--include-archived]

set -euo pipefail

INCLUDE_ARCHIVED=false
for arg in "$@"; do
  case $arg in
    --include-archived) INCLUDE_ARCHIVED=true ;;
    *)
      echo "Unknown argument: $arg"
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=.env
source "$SCRIPT_DIR/.env"

# Fetch all repos from Gitea (paginate to get all results)
repos=""
page=1
while true; do
  page_data=$(curl -s \
      -H "Authorization: token $GITEA_TOKEN" \
    "$GITEA_URL/api/v1/repos/search?limit=50&page=$page")
  page_repos=$(echo "$page_data" | jq -r '.data[] | select(.owner.login == "'"$GITEA_USER"'") | .name')
  [ -z "$page_repos" ] && break
  repos=$(printf "%s\n%s" "$repos" "$page_repos")
  page=$((page + 1))
done
repos=$(echo "$repos" | sed '/^$/d')

for repo in $repos; do
  echo "--- $repo ---"

  # 1. Create GitHub repo if it doesn't exist
  github_repo=$(curl -s \
      -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$GITHUB_USER/$repo")
  http_code=$(echo "$github_repo" | jq -r 'if .id then "200" else "404" end')

  if [ "$http_code" = "404" ]; then
    echo "  Creating GitHub repo $GITHUB_USER/$repo..."
    github_repo=$(curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Content-Type: application/json" \
        "https://api.github.com/user/repos" \
      -d "{\"name\": \"$repo\", \"private\": false}")
    echo "  $(echo "$github_repo" | jq -r '.full_name // .message')"
  else
    echo "  GitHub repo already exists, skipping creation."
  fi

  # Skip archived repos unless --include-archived is set
  is_archived=$(echo "$github_repo" | jq -r '.archived // false')
  if [ "$is_archived" = "true" ] && [ "$INCLUDE_ARCHIVED" = "false" ]; then
    echo "  GitHub repo is archived, skipping. (use --include-archived to force)"
    continue
  fi

  # 2. Tag GitHub repo with gitea-mirror topic
  existing_topics=$(curl -s \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "Accept: application/vnd.github.mercy-preview+json" \
      "https://api.github.com/repos/$GITHUB_USER/$repo/topics" |
  jq -r '.names // []')
  if echo "$existing_topics" | jq -e 'index("gitea-mirror")' >/dev/null 2>&1; then
    echo "  Topic gitea-mirror already set, skipping."
  else
    updated=$(echo "$existing_topics" | jq -c '. + ["gitea-mirror"]')
    curl -s -X PUT \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "Content-Type: application/json" \
      -H "Accept: application/vnd.github.mercy-preview+json" \
      "https://api.github.com/repos/$GITHUB_USER/$repo/topics" \
      -d "{\"names\": $updated}" >/dev/null
    echo "  Tagged with gitea-mirror."
  fi

  # 3. Add push mirror on Gitea → GitHub (skip if mirror already exists)
  existing=$(curl -s \
      -H "Authorization: token $GITEA_TOKEN" \
      "$GITEA_URL/api/v1/repos/$GITEA_USER/$repo/push_mirrors" |
  jq -r '.[] | select(.remote_address | contains("github.com")) | .remote_name' 2>/dev/null || true)

  if [ -n "$existing" ]; then
    echo "  Push mirror already configured, skipping."
  else
    echo "  Setting up Gitea → GitHub push mirror..."
    curl -s -X POST \
      -H "Authorization: token $GITEA_TOKEN" \
      -H "Content-Type: application/json" \
      "$GITEA_URL/api/v1/repos/$GITEA_USER/$repo/push_mirrors" \
    -d "{
	       \"remote_address\": \"https://github.com/$GITHUB_USER/$repo.git\",
	       \"remote_username\": \"$GITHUB_USER\",
	       \"remote_password\": \"$GITHUB_TOKEN\",
	       \"sync_on_commit\": true,
	       \"interval\": \"8h0m0s\"
	     }" | jq -r '.remote_name // .message'
  fi
done

echo ""
echo "Done. Trigger an immediate sync for all mirrors with:"
echo '  curl -X POST -H "Authorization: token $GITEA_TOKEN" $GITEA_URL/api/v1/repos/$GITEA_USER/{repo}/push_mirrors-sync'

#!/usr/bin/env bash
# Set up GitHub push mirrors for all Gitea repositories.
# Gitea is the source of truth; GitHub repos are created as mirrors.
# Usage: ./setup-gitea-github-mirrors.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=.env
source "$SCRIPT_DIR/.env"

# Fetch all repos from Gitea
repos=$(curl -s \
	-H "Authorization: token $GITEA_TOKEN" \
	"$GITEA_URL/api/v1/repos/search?limit=50&token=$GITEA_TOKEN" |
	jq -r '.data[] | select(.owner.login == "'"$GITEA_USER"'") | .name')

for repo in $repos; do
	echo "--- $repo ---"

	# 1. Create GitHub repo if it doesn't exist
	http_code=$(curl -s -o /dev/null -w "%{http_code}" \
		-H "Authorization: token $GITHUB_TOKEN" \
		"https://api.github.com/repos/$GITHUB_USER/$repo")

	if [ "$http_code" = "404" ]; then
		echo "  Creating GitHub repo $GITHUB_USER/$repo..."
		curl -s -X POST \
			-H "Authorization: token $GITHUB_TOKEN" \
			-H "Content-Type: application/json" \
			"https://api.github.com/user/repos" \
			-d "{\"name\": \"$repo\", \"private\": false}" | jq -r '.full_name // .message'
	else
		echo "  GitHub repo already exists, skipping creation."
	fi

	# 2. Add push mirror on Gitea → GitHub (skip if mirror already exists)
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

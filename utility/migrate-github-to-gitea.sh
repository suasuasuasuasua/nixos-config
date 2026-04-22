#!/usr/bin/env bash
# Migrate all GitHub repos (with issues, labels, milestones, releases, PRs) to Gitea
# Usage: ./migrate-github-to-gitea.sh

GITHUB_USER="your-github-username"
GITHUB_TOKEN="ghp_..." # GitHub PAT (repo scope for private, public_repo for public)
GITEA_URL="https://gitea.sua.dev"
GITEA_USER="your-gitea-username"
GITEA_TOKEN="..." # Gitea API token (User Settings → Applications → Generate Token)

repos=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
	"https://api.github.com/user/repos?per_page=100&type=owner" |
	jq -r '.[].name')

for repo in $repos; do
	echo "Migrating $repo..."
	curl -s -X POST "$GITEA_URL/api/v1/repos/migrate" \
		-H "Authorization: token $GITEA_TOKEN" \
		-H "Content-Type: application/json" \
		-d "{
      \"clone_addr\": \"https://github.com/$GITHUB_USER/$repo\",
      \"auth_token\": \"$GITHUB_TOKEN\",
      \"repo_name\": \"$repo\",
      \"repo_owner\": \"$GITEA_USER\",
      \"service\": \"github\",
      \"issues\": true,
      \"labels\": true,
      \"milestones\": true,
      \"releases\": true,
      \"pull_requests\": true,
      \"mirror\": false,
      \"private\": false
    }" | jq -r '.full_name // .message'
done

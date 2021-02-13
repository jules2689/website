#!/usr/bin/env bash

# 1 = commit message
# 2 = actor:repo_token
# 3 = repository name and owner
# 4 = branch
# 5 = thing to add

remote_repo="https://$2@github.com/$3.git"

echo "Running Commit.sh"
echo "Committing : $1"
echo "Push $5 to branch $4 in repo ${remote_repo}"
echo "=================================="
echo "Setting Config for Git"
git config --local user.email "action@github.com"
git config --local user.name "GitHub Action"
echo "=================================="

if [ -z "$(git status --porcelain)" ]; then 
  echo "Nothing to commit, exiting"
  exit 1
fi

git add -f "$5"
git commit -m "$1"
git push "${remote_repo}" "HEAD:$4" --follow-tags

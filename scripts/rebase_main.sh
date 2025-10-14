#!/usr/bin/env bash
set -euo pipefail

BRANCH="main"
UPSTREAM="upstream"

echo "Fetching latest upstream..."
git fetch "$UPSTREAM"

echo "Checking out main branch..."
git checkout "$BRANCH"

echo "Rebasing $BRANCH onto $UPSTREAM/main..."
if git rebase "$UPSTREAM/main"; then
  echo "✅ Rebase successful! Pushing updates..."
  git push origin "$BRANCH" --force-with-lease
else
  echo "❌ Rebase failed! Aborting and notifying..."
  git rebase --abort

  if command -v gh &>/dev/null; then
    gh issue create \
      --title "Rebase conflict on $BRANCH" \
      --body "Automatic rebase of $BRANCH onto $UPSTREAM/main failed. Please resolve conflicts manually." \
      || echo "::warning::GitHub CLI not authenticated, unable to create issue."
  else
    echo "::error::Automatic rebase failed. Please resolve manually."
  fi

  exit 1
fi

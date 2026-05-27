#!/usr/bin/env bash
# new-branch.sh — Helper tạo branch đúng convention

set -e

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: ./scripts/new-branch.sh [lane] [slug]"
  echo "Lanes: tiny, normal, high-risk, docs, chore, experiment"
  echo "Example: ./scripts/new-branch.sh normal article-pho-bo"
  exit 1
fi

LANE=$1
SLUG=$2

# Validate lane
case "$LANE" in
  tiny|normal|high-risk|docs|chore|experiment) ;;
  *) echo "❌ Invalid lane: $LANE"; exit 1 ;;
esac

# Validate slug
if ! echo "$SLUG" | grep -qE '^[a-z0-9][a-z0-9-]*[a-z0-9]$'; then
  echo "❌ Invalid slug: $SLUG"
  echo "   Rules: lowercase, dash-separated, no leading/trailing dash"
  exit 1
fi

if [ ${#SLUG} -gt 50 ]; then
  echo "❌ Slug too long (>50 chars)"
  exit 1
fi

# Pull main first
echo "📥 Pulling main..."
git checkout main
git pull

# Create branch
BRANCH="$LANE/$SLUG"
git checkout -b "$BRANCH"

echo "✅ Created branch: $BRANCH"
echo ""
echo "Next steps:"
echo "  1. Make changes"
echo "  2. Commit with: git commit -m \"$LANE: description\""
echo "  3. Push: git push -u origin $BRANCH"
echo "  4. Open PR: gh pr create  (or /pr in Claude)"

#!/usr/bin/env bash
# pr-check.sh — Pre-flight validation trước khi mở PR
# Usage: ./scripts/pr-check.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

ERRORS=0
WARNINGS=0

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🚀 PR Pre-flight Check${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 1. Check branch
BRANCH=$(git branch --show-current)
echo -e "📌 Current branch: ${BLUE}$BRANCH${NC}"

if [[ "$BRANCH" == "main" ]]; then
  echo -e "${RED}❌ Cannot create PR from main. Switch to a feature branch.${NC}"
  ERRORS=$((ERRORS + 1))
fi

# 2. Check branch naming
VALID_PREFIXES=("tiny/" "normal/" "high-risk/" "docs/" "chore/" "experiment/")
VALID=false
for prefix in "${VALID_PREFIXES[@]}"; do
  if [[ "$BRANCH" == "$prefix"* ]]; then
    VALID=true
    LANE="${prefix%/}"
    break
  fi
done

if [[ "$VALID" == "false" ]]; then
  echo -e "${RED}❌ Branch name doesn't match convention.${NC}"
  echo -e "   Expected: [lane]/[slug] where lane is one of: tiny, normal, high-risk, docs, chore, experiment"
  ERRORS=$((ERRORS + 1))
else
  echo -e "${GREEN}✅ Branch naming OK${NC} (lane: $LANE)"
fi

# 3. Check uncommitted changes
if ! git diff-index --quiet HEAD --; then
  echo -e "${RED}❌ Uncommitted changes. Commit before /pr.${NC}"
  ERRORS=$((ERRORS + 1))
else
  echo -e "${GREEN}✅ Working directory clean${NC}"
fi

# 4. Check has commits ahead of main
COMMITS_AHEAD=$(git rev-list --count main..HEAD 2>/dev/null || echo "0")
if [[ "$COMMITS_AHEAD" == "0" ]]; then
  echo -e "${RED}❌ No commits ahead of main. Nothing to PR.${NC}"
  ERRORS=$((ERRORS + 1))
else
  echo -e "${GREEN}✅ $COMMITS_AHEAD commits ahead of main${NC}"
fi

# 5. Check commit message conventions
echo ""
echo -e "📝 Checking commit messages..."
INVALID_COMMITS=$(git log main..HEAD --pretty=format:"%s" | grep -vE "^(tiny|normal|high-risk|feat|fix|docs|chore|refactor|test|ci):" || true)

if [[ -n "$INVALID_COMMITS" ]]; then
  echo -e "${YELLOW}⚠️  Some commits don't follow conventional format:${NC}"
  echo "$INVALID_COMMITS" | while read -r line; do
    echo -e "   ${YELLOW}→ $line${NC}"
  done
  echo -e "${YELLOW}   Expected format: [type]: [description]${NC}"
  WARNINGS=$((WARNINGS + 1))
else
  echo -e "${GREEN}✅ All commits follow conventional format${NC}"
fi

# 6. Check frontmatter in changed .md files
echo ""
echo -e "📋 Checking frontmatter in changed files..."

CHANGED_MD=$(git diff --name-only main...HEAD | grep -E '\.md$' || true)

if [[ -n "$CHANGED_MD" ]]; then
  while IFS= read -r file; do
    [[ -z "$file" ]] && continue
    [[ ! -f "$file" ]] && continue

    # Skip files not requiring frontmatter
    case "$file" in
      README.md|CHANGELOG.md|CONTRIBUTING.md|CLAUDE.md|AGENTS.md|CODEOWNERS|.github/*|_context/*|_meta/*)
        continue
        ;;
    esac

    # Only check shared/ files — required fields differ per path (mirror CI workflow)
    if [[ "$file" == shared/* ]]; then
      if ! head -1 "$file" | grep -q "^---"; then
        echo -e "${RED}❌ $file: Missing frontmatter${NC}"
        ERRORS=$((ERRORS + 1))
      else
        # Required fields per path category (must match .github/workflows/validate-frontmatter.yml)
        REQUIRED_FIELDS=""
        case "$file" in
          shared/adr/*)            REQUIRED_FIELDS="id title date deciders status" ;;
          shared/content/*)        REQUIRED_FIELDS="title author created status type" ;;
          shared/retrospectives/*) REQUIRED_FIELDS="period date author" ;;
        esac

        if [[ -n "$REQUIRED_FIELDS" ]]; then
          FM=$(sed -n '/^---$/,/^---$/p' "$file" | head -n -1 | tail -n +2)
          for required in $REQUIRED_FIELDS; do
            if ! echo "$FM" | grep -q "^${required}:"; then
              echo -e "${RED}❌ $file: Missing field '${required}' in frontmatter${NC}"
              ERRORS=$((ERRORS + 1))
            fi
          done
        fi
      fi
    fi
  done <<< "$CHANGED_MD"

  if [[ "$ERRORS" == "0" ]]; then
    echo -e "${GREEN}✅ All frontmatter looks good${NC}"
  fi
else
  echo -e "${BLUE}ℹ️  No markdown files changed${NC}"
fi

# 7. Check high-risk has Decision Record
if [[ "$LANE" == "high-risk" ]]; then
  echo ""
  echo -e "🔴 High-risk PR detected. Checking Decision Record..."

  HAS_DR=$(git diff --name-only main...HEAD | grep -E "(shared/DECISIONS\.md|shared/adr/)" || true)
  if [[ -z "$HAS_DR" ]]; then
    echo -e "${RED}❌ High-risk PR must include Decision Record:${NC}"
    echo -e "   - Update shared/DECISIONS.md (add D-NNN entry), OR"
    echo -e "   - Add shared/adr/ADR-NNN-*.md"
    ERRORS=$((ERRORS + 1))
  else
    echo -e "${GREEN}✅ Decision Record included${NC}"
  fi
fi

# 8. Check file naming convention
echo ""
echo -e "📁 Checking file naming..."

NAMING_ERRORS=0
while IFS= read -r file; do
  [[ -z "$file" ]] && continue
  [[ ! -f "$file" ]] && continue

  basename=$(basename "$file")

  # Content files
  if [[ "$file" == shared/content/* ]]; then
    if ! echo "$basename" | grep -qE '^[a-z0-9][a-z0-9-]*-[0-9]{4}-[0-9]{2}-[0-9]{2}\.md$'; then
      echo -e "${RED}❌ $file: must match [slug]-YYYY-MM-DD.md${NC}"
      NAMING_ERRORS=$((NAMING_ERRORS + 1))
    fi
  fi

  # ADR files
  if [[ "$file" == shared/adr/* ]] && [[ "$basename" != *.gitkeep ]]; then
    if ! echo "$basename" | grep -qE '^ADR-[0-9]{3}-[a-z0-9-]+\.md$'; then
      echo -e "${RED}❌ $file: must match ADR-NNN-slug.md${NC}"
      NAMING_ERRORS=$((NAMING_ERRORS + 1))
    fi
  fi
done <<< "$CHANGED_MD"

if [[ "$NAMING_ERRORS" == "0" ]]; then
  echo -e "${GREEN}✅ All file names follow convention${NC}"
else
  ERRORS=$((ERRORS + NAMING_ERRORS))
fi

# Summary
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [[ "$ERRORS" == "0" ]]; then
  echo -e "${GREEN}✅ ALL CHECKS PASSED${NC}"
  [[ "$WARNINGS" -gt 0 ]] && echo -e "${YELLOW}   (with $WARNINGS warnings)${NC}"
  echo ""
  echo -e "🚀 Ready to PR! Run:"
  echo -e "   ${BLUE}gh pr create${NC}  or  ${BLUE}/pr in Claude${NC}"
  exit 0
else
  echo -e "${RED}❌ $ERRORS ERRORS, $WARNINGS WARNINGS${NC}"
  echo ""
  echo -e "Fix issues above before creating PR."
  exit 1
fi

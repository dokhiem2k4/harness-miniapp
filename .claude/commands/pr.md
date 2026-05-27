---
description: Tạo Pull Request từ branch hiện tại (thay /submit)
allowed-tools: Bash, Read, Write
---

# /pr — Tạo Pull Request

Bạn là Claude, giúp member mở Pull Request đúng quy trình.

## Quy trình

### Bước 1: Kiểm tra trạng thái git

Chạy:
```bash
git status
git branch --show-current
git log main..HEAD --oneline
```

Verify:
- Branch hiện tại KHÔNG phải `main`
- Branch tên đúng convention: `[lane]/[slug]`
- Có ít nhất 1 commit chưa merge vào main
- Working directory clean (không có uncommitted changes)

Nếu có vấn đề:
- Branch là main → STOP, báo "Đừng PR từ main. Tạo branch mới với /intake"
- Có uncommitted changes → "Bạn còn changes chưa commit. Commit trước rồi /pr"

### Bước 2: Suy ra lane từ branch name

```bash
BRANCH=$(git branch --show-current)
LANE=$(echo $BRANCH | cut -d/ -f1)
```

Match với template:
- `tiny/*` → `tiny.md`
- `normal/*` → `normal.md`
- `high-risk/*` → `high-risk.md`
- `docs/*` → `normal.md`
- `chore/*` → `tiny.md`

### Bước 3: Pre-flight checks

Chạy local validation:

```bash
./scripts/pr-check.sh
```

Nếu fail → STOP, hiển thị lỗi, hướng dẫn fix.

### Bước 4: Push branch lên remote

```bash
git push -u origin $BRANCH
```

### Bước 5: Generate PR body

Dựa vào lane + commit messages + diff, fill template phù hợp.

**Đọc:**
- Template file: `.github/PULL_REQUEST_TEMPLATE/[lane].md`
- Commit messages: `git log main..HEAD --pretty=format:"%s%n%b"`
- Files changed: `git diff --name-only main...HEAD`

**Fill các section:**

- **What/TL;DR**: Tổng hợp từ commit messages
- **Why**: Lấy từ commit body hoặc hỏi user nếu thiếu
- **Files changed**: Auto từ git diff
- **Lane checkbox**: Tự tick theo branch prefix
- **Self-check**: Tự verify từng item rồi tick

**Cho high-risk:**
- Hỏi user: "Issue thảo luận direction là issue nào?" → fill "Discussion issue: #N"
- Verify Decision Record có trong diff không

### Bước 6: Show preview cho user

```
📋 PULL REQUEST PREVIEW
━━━━━━━━━━━━━━━━━━━━━━

Branch: [branch]
Lane: [emoji + lane]
Target: main

Title: [auto-generated từ commit cuối]

Body:
[Toàn bộ PR body đã fill]

Files changed: [n]
Commits: [n]

Action:
   1 → Create PR (sẽ chạy: gh pr create)
   2 → Edit body trước
   3 → Cancel
```

### Bước 7: Nếu user OK → Tạo PR

```bash
gh pr create \
  --base main \
  --head $BRANCH \
  --title "[title]" \
  --body-file /tmp/pr-body.md \
  --template [lane].md
```

Báo kết quả:

```
🎉 PR CREATED
━━━━━━━━━━━━━━━
URL: [pr-url]
Number: #[n]
Status: open

📋 Auto-applied:
   ✅ Labels: lane:[lane], area:[area]
   ✅ Reviewers (CODEOWNERS): @user1, @user2
   ✅ CI workflows started

⏱️ Next steps:
   1. CI sẽ chạy trong ~2 phút
   2. Reviewers sẽ được notify
   3. Theo dõi: gh pr view --web

💡 Nếu CI fail:
   - Đọc log: gh pr checks
   - Fix local, commit, push lại branch
   - PR sẽ auto-update
```

### Bước 8: (Optional) Watch CI

Nếu user muốn:

```bash
gh pr checks --watch
```

Hiển thị real-time CI status.

## Quy tắc

- ✅ Verify branch + commits trước khi push
- ✅ Pre-flight checks LOCAL trước, không spam CI
- ✅ Auto-fill PR body từ context, hỏi user chỉ khi cần
- ❌ KHÔNG force push (`--force`) khi PR đã có review
- ❌ KHÔNG tạo PR từ main → main
- ❌ KHÔNG bypass CI bằng admin override

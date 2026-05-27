---
description: Ghi trace log từ git history + session context
allowed-tools: Bash, Read, Write
---

# /trace — Ghi trace log (Git-aware)

Bạn là Claude. Trong GitHub workflow, trace giờ tự fill nhiều phần từ git history.

## Quy trình

### Bước 1: Detect context

```bash
# Branch hiện tại
BRANCH=$(git branch --show-current)
LANE=$(echo $BRANCH | cut -d/ -f1)

# User
USER=$(git config user.name)

# Commits trong branch này
git log main..HEAD --pretty=format:"%h %s"

# Files đã thay đổi
git diff --name-only main...HEAD
```

### Bước 2: Auto-fill template

Tạo file: `.work/traces/[YYYY-MM-DD]-[user]-[branch-slug].md`

(`.work/traces/` được gitignore — chỉ local trên máy member)

```markdown
---
date: [auto]
user: "[git user.name]"
branch: "[branch]"
lane: "[tiny/normal/high-risk]"
outcome: "[hỏi user: success/partial/blocked/abandoned]"
commits: [count]
files_changed: [count]
---

# Trace: [Branch slug]

## 🎬 Bối cảnh
[Hỏi user 1 câu — auto đoán từ branch name]

## 🛠️ Bạn đã làm gì
[Auto từ commit messages, format:]
1. [commit 1 message]
2. [commit 2 message]
...

## 📂 Files affected
[Auto từ git diff --stat]

## 💬 PR liên quan
[Nếu đã có PR: gh pr view --json url,number]

## ✅ Outcome
[Hỏi user]

## 🧠 Bài học (nếu có)
[Hỏi user — không bắt buộc]
- 

## 🚨 Friction phát hiện
[Hỏi user — có thể skip nếu không có]

Nếu có friction → đề xuất:
   gh issue create --template friction.yml

## 🔗 Liên quan
- Branch: [branch]
- Commits: [list hashes]
- PR: [url nếu có]
- Closes issues: [parse từ commits "Closes #N"]
```

### Bước 3: Show preview, hỏi confirm

```
📝 TRACE PREVIEW (auto-filled)
━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Toàn bộ trace, các phần auto đánh dấu ✓ và manual đánh dấu ?]

Phần cần bạn điền (manual):
   ? Bối cảnh
   ? Outcome (chọn: success/partial/blocked/abandoned)
   ? Bài học (optional)
   ? Friction (optional)

Action:
   1 → Save trace (skip manual parts nếu không quan trọng)
   2 → Fill manual parts trước
   3 → Cancel
```

### Bước 4: Nếu save

Tạo file trong `.work/traces/`.

Nếu user mention friction → đề xuất:

```
💡 Friction detected. Tạo GitHub issue?

   gh issue create --template friction.yml --title "[FRICTION] [topic]"
   
Bạn có muốn tôi tạo issue ngay không?
```

### Bước 5: Stats cá nhân

Sau save:

```
✅ Trace saved: .work/traces/[file]

📊 Your stats (past 7 days):
   Traces logged: [n]
   PRs merged: [n]
   Issues opened: [n]
   Friction reported: [n]
```

## Quy tắc

- ✅ Trace GIỜ tự động từ git — chỉ hỏi user phần "lessons" và "friction"
- ✅ Trace để LOCAL trong `.work/` — không sync, không spam repo
- ✅ Friction quan trọng hơn → đề xuất tạo GitHub issue
- ❌ Không tạo trace nếu lane = tiny (theo intake-rules)
- ❌ Không commit `.work/` (đã có trong .gitignore)

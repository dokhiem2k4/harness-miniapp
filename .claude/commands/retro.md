---
description: Weekly retrospective từ merged PRs + closed issues
allowed-tools: Bash, Read, Write
---

# /retro — Weekly Retrospective (Git-aware)

Bạn là Claude. Trong GitHub workflow, retro tự tổng hợp từ git data.

## Quy trình

### Bước 1: Xác định khoảng thời gian

Hỏi user (default 7 ngày):

```
📅 Retrospective period?
   1 → Tuần này (7 ngày qua)
   2 → Sprint (14 ngày)
   3 → Custom range
```

### Bước 2: Gather data từ GitHub

```bash
# Merged PRs
gh pr list --state merged --search "merged:>=YYYY-MM-DD" --json number,title,labels,author,mergedAt,additions,deletions

# Open PRs (vẫn đang chờ)
gh pr list --state open --json number,title,labels,createdAt

# Closed issues
gh issue list --state closed --search "closed:>=YYYY-MM-DD" --json number,title,labels

# Friction issues
gh issue list --label friction --state all --json number,title,createdAt,state

# Activity per author
gh pr list --state merged --search "merged:>=YYYY-MM-DD" --json author | jq '...'
```

### Bước 3: Đọc traces local (nếu có)

Glob `.work/traces/[date]-*.md` trong khoảng → extract:
- Outcome distribution
- Friction mentioned

### Bước 4: Phân tích

**Stats:**
- Merged PRs by lane (tiny/normal/high-risk)
- Average time-to-merge per lane
- Top contributors
- CI failure rate
- Friction issues opened vs closed

**Patterns:**
- Common CI failures → workflow cần fix?
- Friction lặp lại → harness cần update?
- High-risk PRs có Decision Record không?

### Bước 5: Generate retrospective

Tạo file: `shared/retrospectives/[YYYY-MM-DD]-retro.md` (lưu ý: cần PR để merge file này)

```markdown
---
period: "[start] → [end]"
date: [today]
author: "[team-lead]"
prs_merged: [n]
friction_reported: [n]
---

# Retrospective — [Period]

## 📊 Stats

### Activity
- **Merged PRs**: [n]
  - 🟢 Tiny: [n] (avg [X]h to merge)
  - 🟡 Normal: [n] (avg [X]d to merge)
  - 🔴 High-risk: [n] (avg [X]d to merge)
- **Closed issues**: [n]
- **New friction reports**: [n]
- **CI runs**: [n] ([%] passed first try)

### Contributors (top 3)
1. @[user]: [n] PRs merged, [n] reviews
2. @[user]: ...
3. @[user]: ...

## 🎉 Going Well

[Pattern positives detect được:]

- [Pattern 1, vd: "Tiny PRs merge trong 1 ngày — workflow rất smooth"]
  - Evidence: PRs #X, #Y, #Z all merged within 24h
- [Pattern 2]

## 🔥 Going Wrong

[Pattern issues. Quote cụ thể từ PR comments hoặc traces:]

- [Vấn đề 1] — [n] PRs ảnh hưởng
  > "[quote từ PR comment/trace]"
  > — PR #N

- [Vấn đề 2]

## 💡 Insights

[Phát hiện mới về quy trình:]

- [Insight 1]
- [Insight 2]

## 🛠️ Action items

| Action | Owner | Deadline | Status |
|--------|-------|----------|--------|
| [action 1] | @user | [date] | ⬜ |

## 🧬 Harness changes đề xuất

[Open issues với label `harness-improvement`:]

- [ ] [Sửa workflow X để check Y]
- [ ] [Thêm rule Z vào conventions.md]
- [ ] [Tạo slash command mới]

→ Mở PR với label `area:meta` cho mỗi item

## 📋 Friction patterns

Top friction issues:
1. **[friction title]** — gặp [n] lần
   - Issues: #X, #Y
   - Suggested fix: [from issue comments]

## 📝 Notable PRs

### High-risk merged this week
- PR #N: [title] — D-NNN created
- ...

### Stale PRs (>3 days waiting)
- PR #N: [title] — @author đợi @reviewer

## 🎯 Next sprint focus

[Top 3 priorities cho sprint sau]
1. 
2. 
3. 
```

### Bước 6: Preview + confirm

Show retro draft. Hỏi user edit/save.

### Bước 7: Save + push

Save vào `shared/retrospectives/[YYYY-MM-DD]-retro.md` ở branch mới:

```bash
git checkout -b normal/retro-[YYYY-MM-DD]
git add shared/retrospectives/[file].md
git commit -m "normal: weekly retrospective [YYYY-MM-DD]"
git push -u origin normal/retro-[YYYY-MM-DD]
gh pr create --template normal.md
```

### Bước 8: Auto-create harness improvement issues

Cho mỗi item trong "Harness changes đề xuất", offer tạo issue:

```
💡 Tạo issues cho action items?

   1 → Yes, tạo issue cho từng action
   2 → No, tôi sẽ tạo thủ công sau
```

Nếu yes:

```bash
for action in actions:
  gh issue create --label "harness-improvement,proposal" --title "[HARNESS] [action]"
```

## Quy tắc

- ✅ Stats phải từ DATA THẬT (GitHub API + traces)
- ✅ Quote cụ thể từ PRs/issues, không generic
- ✅ Action items SMART
- ❌ Không skip "Going Wrong" dù tuần suôn sẻ
- ❌ Không commit thẳng — luôn qua PR

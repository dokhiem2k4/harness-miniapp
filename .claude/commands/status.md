---
description: Dashboard team status từ GitHub
allowed-tools: Bash, Read
---

# /status — Team Dashboard

Bạn là Claude. Show snapshot tình trạng team theo GitHub data.

## Quy trình

### Bước 1: Gather data

```bash
# Open PRs
gh pr list --state open --json number,title,labels,author,createdAt,reviewDecision

# Recent merges (past 7 days)
gh pr list --state merged --search "merged:>=$(date -v-7d +%Y-%m-%d)" --json number,mergedAt

# Open issues by label
gh issue list --label friction --state open --json number,title,createdAt
gh issue list --label proposal --state open --json number,title
gh issue list --label bug --state open --json number,title

# Recent CI runs
gh run list --limit 20 --json status,conclusion,name,createdAt

# Latest commits to main
git log main --since="7 days ago" --oneline
```

### Bước 2: Render dashboard

```
📊 TEAM HARNESS STATUS — [datetime]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📥 OPEN PULL REQUESTS ([n] total)
   🔴 High-risk: [n] ([X] đợi >3 ngày)
   🟡 Normal: [n] ([X] đợi >2 ngày)
   🟢 Tiny: [n] ([X] đợi >1 ngày)
   
   Stale (>3 days):
   #[N] - [title] by @[user] - [X days ago]
   #[N] - ...

📈 ACTIVITY (Past 7 days)
   ✅ PRs merged: [n]
      🟢 [n] tiny, 🟡 [n] normal, 🔴 [n] high-risk
   📝 Issues closed: [n]
   🔥 Friction reports: [n] new
   🚀 CI runs: [n] (success: [%])
   📊 Avg time to merge:
      🟢 Tiny: [Xh]
      🟡 Normal: [Xd]
      🔴 High-risk: [Xd]

🎯 BACKLOG (GitHub Issues)
   🔥 Friction open: [n]
   💡 Proposals open: [n]
   🐛 Bugs open: [n]
   
   Top friction patterns (>2 mentions):
   - [pattern]: [n] issues
   - [pattern]: [n] issues

👥 TEAM LOAD (past 7 days)
   1. @[user]: [n] PRs merged, [n] reviews given
   2. @[user]: [n] PRs merged
   3. @[user]: [n] PRs merged

✅ SHARED CONTENT
   Total content files: [n]
   Active decisions (D-NNN): [n]
   ADRs: [n]
   Latest CHANGELOG entry: [date]

🚨 ATTENTION NEEDED
[Chỉ show nếu có:]
   ⚠️ [n] high-risk PRs đợi >3 ngày
   ⚠️ [n] CI runs failed gần đây (cùng workflow)
   ⚠️ [n] friction issues >2 tuần không response
   ⚠️ PR #[N] mention bạn — reviewer assignment

💡 SUGGESTIONS
[Đề xuất action:]
   • Review [n] stale PRs (chạy /review)
   • Triage friction issues (label `friction`)
   • Generate retrospective (cuối tuần)
```

### Bước 3: Context-aware actions

Detect role + offer relevant actions:

**Cho Member:**
```
Your stats:
   Your open PRs: [n]
   Your assigned issues: [n]
   Your PRs awaiting your action: [n] (reviews, fixes)

Quick actions:
   1 → Xem PR của bạn (gh pr list --author @me)
   2 → Xem issues assigned cho bạn
   3 → Xem PRs đợi review của bạn
```

**Cho Team Lead:**
```
Lead actions:
   1 → /review (process queue)
   2 → /retro (generate weekly retro)
   3 → Triage friction issues
   4 → Open browser to repo insights
```

### Bước 4: Filter theo role

Detect user role:
- Check git config user.email
- Match với `_context/team-members.md`
- Hoặc check CODEOWNERS — nếu user là owner widespread → likely team lead

Adjust output focus theo role:
- **Member**: Focus PRs/issues của họ
- **Team Lead**: Focus tổng quan + queue cần xử lý
- **Reviewer**: Focus PRs cần họ review

## Quy tắc

- ✅ Số liệu REAL từ GitHub API + git
- ✅ Output scannable trong 30 giây
- ✅ Highlight urgent items
- ❌ Không show data quá chi tiết — chỉ aggregate
- ❌ Không expose info nhạy cảm (vd: review comments)

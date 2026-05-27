---
description: Team lead xem queue PR đang chờ review
allowed-tools: Bash, Read, Edit
---

# /review — Team Lead review queue

Bạn là Claude, giúp team lead xử lý PRs đang chờ review.

## Quy trình

### Bước 1: List open PRs

```bash
gh pr list --state open --json number,title,labels,author,createdAt,reviewDecision,headRefName
```

Sort priority:
1. 🔴 High-risk (label `lane:high-risk`)
2. 🟡 Normal có CI passed
3. 🟢 Tiny

Filter:
- Loại bỏ PR đã approved
- Loại bỏ PR của chính team lead (cần người khác review)
- Highlight PR đợi >3 ngày

### Bước 2: Show queue

```
📥 REVIEW QUEUE — [n] open PRs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 HIGH-RISK ([n] items)

#N | [title] | @author | [Xd Yh ago]
   Branch: high-risk/[slug]
   CI: ✅ passed / ❌ failed / ⏳ running
   Decision Record: ✅ included / ❌ missing
   [Quick TL;DR từ PR body]

🟡 NORMAL ([n] items)

#N | [title] | @author | [Xd ago]
   CI: ✅ passed
   ...

🟢 TINY ([n] items)

#N | [title] | @author | [Xh ago]

⚠️ ATTENTION:
   - PR #X đợi >3 ngày
   - PR #Y CI fail nhưng chưa fix
   - PR #Z thiếu Decision Record (high-risk)

Chọn PR để review (gõ số), hoặc:
   all     → review tuần tự
   stale   → ưu tiên PR đợi lâu nhất
```

### Bước 3: Khi user chọn PR

```bash
gh pr view [N] --json title,body,files,commits
gh pr diff [N]
```

Đọc `_meta/validation-matrix.md` cho checklist phù hợp lane.

Show:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━
📄 REVIEWING: PR #N — [title]
━━━━━━━━━━━━━━━━━━━━━━━━━━

Author: @username
Branch: [branch] → main
Lane: [lane]
CI: [status]
Files: [n] changed

📋 PR Body summary:
[Tóm tắt 3-5 dòng]

🔍 VALIDATION CHECKLIST (auto-checked):

CI Checks:
- [✅] Frontmatter validation
- [✅] Schema validation
- [✅] Markdown lint
- [✅] File naming

Content (manual review needed):
- [ ] TL;DR rõ ràng
- [ ] Câu chủ đề mỗi đoạn
- [ ] Nguồn được trích dẫn
- [ ] Tone & voice consistent
- [ ] Không mâu thuẫn DECISIONS

[Nếu high-risk]
High-risk specific:
- [✅/❌] Decision Record D-NNN added
- [✅/❌] ADR added (nếu kiến trúc)
- [✅/❌] Migration path documented
- [✅/❌] Rollback plan included

Action:
   1 → Approve (gh pr review --approve)
   2 → Request changes (cần comment)
   3 → Comment only (chưa quyết)
   4 → Skip — xem PR khác
   5 → Open in browser (gh pr view --web)
```

### Bước 4a: Approve

```bash
gh pr review [N] --approve --body "[approval message]"
```

Hỏi user có muốn merge luôn không (nếu CI pass + đủ approvals):

```bash
gh pr merge [N] --squash --delete-branch
```

Báo:

```
✅ APPROVED PR #N
━━━━━━━━━━━━━━━━
[Nếu merged]
   ✅ Merged to main (squash + delete branch)
   ✅ CHANGELOG.md will auto-update via workflow
   
[Nếu chưa merge]
   ⏳ Đợi approvals khác hoặc CI complete
```

### Bước 4b: Request changes

Hỏi user comment cụ thể (multi-line).

```bash
gh pr review [N] --request-changes --body "[comment]"
```

### Bước 4c: Comment only

```bash
gh pr review [N] --comment --body "[comment]"
```

### Bước 5: Continue hoặc exit

Sau mỗi action:

```
Tiếp theo?
   next → PR tiếp theo trong queue
   stats → Show queue stats lại
   exit → Kết thúc
```

Khi exit, summary:

```
📊 REVIEW SESSION SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━
Reviewed: [n] PRs
✅ Approved: [n] (merged: [n])
🔄 Changes requested: [n]
💬 Commented: [n]

Còn [n] PRs trong queue.
```

## Quy tắc

- ❌ Không tự approve PR mà không user confirm
- ❌ Không merge PR có CI fail
- ❌ Không bypass CODEOWNERS (cần đúng người review)
- ✅ Comment cụ thể, không "LGTM" trống
- ✅ Nếu PR thiếu Decision Record cho high-risk → request changes

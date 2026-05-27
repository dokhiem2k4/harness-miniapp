---
description: Tạo ADR mới (Architecture Decision Record)
allowed-tools: Read, Glob, Bash, Write
---

# /adr — Tạo Architecture Decision Record

Bạn là Claude, giúp tạo 1 ADR mới đúng quy trình.

## Topic từ user

$ARGUMENTS

## Quy trình

### Bước 1: Đọc ADRs hiện có

Glob `shared/adr/ADR-*.md`. Đọc tất cả để:
- Biết ADR tiếp theo là số nào (ADR-001 → ADR-002 → ...)
- Tránh duplicate hoặc mâu thuẫn với decisions cũ
- Hiểu pattern viết ADR của team

### Bước 2: Đọc context

- `_context/architecture.md` — Nguyên tắc thiết kế
- `_meta/templates/adr.md` — Template chuẩn
- `shared/DECISIONS.md` — Decisions ngắn

### Bước 3: Verify đây là HIGH-RISK task

ADR luôn là high-risk vì:
- Quyết định kiến trúc gắn với code dài hạn
- Khó revert
- Ảnh hưởng nhiều người

⚠️ **CHECK**: User đã tạo issue thảo luận chưa?

Nếu chưa → STOP, hỏi user:

```
ADR là high-risk task. Trước khi tạo, cần:

1. Issue thảo luận direction trên GitHub:
   gh issue create --template proposal.yml \
     --title "[PROPOSAL] ADR-XXX: [topic]"

2. Có buy-in từ ít nhất 1 reviewer

Bạn đã có issue chưa? (y/n)
```

Nếu user nói "y" → hỏi issue number, ghi vào ADR.

Nếu user nói "n" hoặc "skip" (vì đây là setup ban đầu) → confirm:

```
⚠️ Bạn đang skip discussion phase. OK chỉ cho:
- Tháng đầu setup (chưa có team đầy đủ)
- Trivial ADRs (vd: code style)

Vẫn tiếp tục? (y/n)
```

### Bước 4: Phân tích topic

Trước khi viết, đảm bảo có đủ thông tin:

- **Topic là gì?** (cụ thể, không chung chung)
- **Context bắt buộc:** Tại sao cần quyết bây giờ?
- **Constraints:** Có bị bound bởi super app/RN limit nào không?
- **Stakeholders:** Quyết định này ảnh hưởng ai?

Nếu user cung cấp thiếu → HỎI từng câu, đừng tự đoán.

### Bước 5: Brainstorm alternatives

Tốt nhất **3+ options** (không chỉ 2). Vd cho ADR "State management":

- Redux Toolkit
- Zustand
- Jotai
- React Context only (do nothing)

Phải có Option "Status quo" hoặc "Do nothing" để cân nhắc.

### Bước 6: Tạo branch + file

```bash
NEXT_NUMBER=[N+1 từ ADR cuối]
SLUG=[user-provided slug, kebab-case]

git checkout main && git pull
git checkout -b high-risk/adr-${NEXT_NUMBER}-${SLUG}

# Tạo file
touch shared/adr/ADR-${NEXT_NUMBER}-${SLUG}.md
```

### Bước 7: Fill template

Đọc `_meta/templates/adr.md`. Fill với:

**Frontmatter:**
```yaml
---
id: "ADR-NNN"
title: "[Title từ user]"
date: 2026-05-27
deciders: ["@username"]
status: "Proposed"   # Sẽ đổi sau khi merge
tags: [tag1, tag2]
---
```

**Body sections (BẮT BUỘC fill từng cái):**

1. **Status** — Proposed lúc tạo, Active sau merge
2. **Context** — 3-4 đoạn về tình hình, vấn đề, áp lực
3. **Decision** — 1-2 câu chốt rõ ràng
4. **Options Considered** — 3+ options với:
   - Mô tả
   - Pros
   - Cons
   - Lý do chọn/loại
5. **Consequences** — Positive + Negative
6. **Migration Plan** — Nếu cần migrate code
7. **Validation Metrics** — Làm sao đo ADR này work
8. **Re-evaluate** — Khi nào revisit

### Bước 8: Update DECISIONS.md

Append entry tóm tắt:

```markdown
## D-NNN → ADR-NNN: [Title]

- **Date:** YYYY-MM-DD
- **Status:** Proposed
- **Details:** [ADR-NNN](./adr/ADR-NNN-slug.md)

### TL;DR
[1-2 câu]
```

Cũng update bảng "Active ADRs" và "Open ADRs":
- Thêm row mới vào "Active ADRs" (status: Proposed lúc đầu)
- Nếu ADR này close 1 item trong "Open ADRs" → tick xong

### Bước 9: Update CHANGELOG.md

Append:

```markdown
## YYYY-MM-DD (Unreleased)

### Decided
- ADR-NNN: [title] — Proposed
```

### Bước 10: Show preview, hỏi confirm

```
📋 ADR PREVIEW
━━━━━━━━━━━━━━━

File: shared/adr/ADR-NNN-slug.md

[Full content preview]

Files changed:
- shared/adr/ADR-NNN-slug.md (new)
- shared/DECISIONS.md (updated)
- shared/CHANGELOG.md (updated)

Action:
   1 → Commit + push (chuẩn bị /pr)
   2 → Edit ADR trước
   3 → Cancel
```

### Bước 11: Nếu user OK → Commit

```bash
git add shared/adr/ADR-NNN-slug.md shared/DECISIONS.md shared/CHANGELOG.md
git commit -m "high-risk(architecture): add ADR-NNN [title]

Proposes [decision].

Discussion: #[issue-number]"

# Push
git push -u origin high-risk/adr-NNN-slug
```

Báo:

```
✅ ADR DRAFT CREATED

📄 File: shared/adr/ADR-NNN-slug.md
🌳 Branch: high-risk/adr-NNN-slug
📝 Commit: [hash]

Next steps:
   1. Run /pr to create Pull Request
   2. PR sẽ require 2 reviewers approve (high-risk rule)
   3. Sau merge, đổi status từ "Proposed" → "Active"
```

## Quy tắc

- ✅ Mọi ADR phải có 3+ options
- ✅ Phải có "Re-evaluate" timeline (3 / 6 / 12 tháng)
- ✅ Linked với issue discussion (trừ setup ban đầu)
- ✅ Status = Proposed lúc tạo, đổi Active sau merge
- ❌ KHÔNG tạo ADR mâu thuẫn với ADR Active hiện có (phải Supersede)
- ❌ KHÔNG skip alternatives — luôn tìm 3+

---
title: "[Tên spec/feature]"
author: "@dokhiem2k4"
created: YYYY-MM-DD
status: draft | review | approved | deprecated
type: normal
notion_url: "https://notion.so/..."
linear_issue: "PROJ-NNN"
figma_url: "https://figma.com/file/..."
related_adrs: []
related_decisions: []
tags: []
---

# [Tên spec/feature]

> Đây là **index file** trỏ tới Notion. KHÔNG duplicate nội dung từ Notion vào đây.

## 📋 TL;DR

[2-3 dòng tóm tắt — đủ để hiểu mà không cần mở Notion]

## 🌐 Sources of truth

| Loại | Link | Maintained by |
|------|------|---------------|
| 📄 Full spec / PRD | [Notion]({notion_url}) | Product team |
| ✅ Tasks / Sprint | [Linear](https://linear.app/...) | Engineering |
| 🎨 Designs / Flows | [Figma]({figma_url}) | Design team |
| 💬 Discussion | [Slack thread](https://...) | Team |

## 🔗 Code locations

Files trong repo liên quan đến spec này:

- `src/features/[feature-name]/` — Main implementation
- `src/services/api/[domain].ts` — API calls
- `tests/features/[feature-name]/` — Tests

## 🧬 Related decisions

- [ADR-XXX](../adr/ADR-XXX-slug.md) — [why]
- [D-XXX](../DECISIONS.md#d-xxx) — [why]

## 📊 Status

- **Started:** [date]
- **Target completion:** [date]
- **Current phase:** Discovery / Design / Implementation / Review / Shipped
- **Blockers:** [list nếu có]

## 📝 Notes (optional)

[Bất kỳ note nào CHỈ có ý nghĩa cho repo, KHÔNG có trong Notion.]
[Vd: "Implementation note: cần dùng pattern X vì super app SDK hạn chế Y"]

## 🔄 Sync log

| Date | What synced | By |
|------|-------------|-----|
| YYYY-MM-DD | Initial index | @user |
| YYYY-MM-DD | Updated link sau khi spec rewrite | @user |

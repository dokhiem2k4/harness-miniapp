---
id: "ADR-002"
title: "Use TypeScript for mini app implementation"
author: "@dokhiem2k4"
created: 2026-05-27
date: 2026-05-27
deciders: ["@dokhiem2k4"]
status: "Proposed"
type: "high-risk"
tags: [tech-stack, language, typescript]
---

# ADR-002: Use TypeScript for mini app implementation

## Status

**Proposed** — Đề xuất ngày 2026-05-27. Chờ 2 reviewers approve để chuyển sang **Active**.

Follow-up từ ADR-001:92 (open question đã liệt kê: "TypeScript or JavaScript? (đề xuất TS)").

## Context

Sau khi ADR-001 chốt dùng React Native cho mini app trên Custom Super App, bước tiếp theo là chọn ngôn ngữ: **TypeScript hay JavaScript**.

Áp lực hiện tại:
- **Mini app sẽ tích hợp super app SDK** — contract gọi sang super app cần type-safety để tránh runtime error trong production (super app review có thể reject mini app crash).
- **Team size & turnover**: team ~7 người, có member mới sẽ vào — cần code self-documenting để onboard nhanh.
- **Greenfield project** — không có legacy JS code phải migrate, chi phí adopt TS = 0 (chỉ là setup tooling).
- **Bundle size constraint** từ super app (TBD trong project-overview.md) — TS biên dịch sang JS, không tăng runtime bundle, nhưng có thể tăng dev dependencies & build time.
- **Convention impact**: chọn TS sẽ thay đổi rất nhiều convention khác (file naming, imports, testing tooling) — đã được phản ánh trong `_context/conventions.md` (đang giả định TS).

`_context/conventions.md:99` đã viết "Sau khi có ADR-002 xác nhận dùng TS" — file conventions đang chờ ADR này để chính thức hoá.

## Decision

**[DRAFT — member fill]** Sử dụng **TypeScript strict mode** cho toàn bộ codebase mini app, bắt đầu từ commit đầu tiên.

Cấu hình strict đề xuất (khớp `_context/architecture.md`):

```json
{
  "strict": true,
  "noUncheckedIndexedAccess": true,
  "exactOptionalPropertyTypes": true,
  "noImplicitOverride": true
}
```

Phiên bản TypeScript: **TBD** (gắn với RN version từ ADR-001).

## Options Considered

### Option 1: TypeScript strict mode ✅ CHỌN (đề xuất)

**Diagram:**
```text
src/*.ts(x)  ──tsc──►  *.js  ──Metro/RePack──►  bundle.js  ──►  Super app runtime
              │
              └──► type-check trong CI (không emit, chỉ verify)
```

**Pros:**
- ✅ Type-safe khi gọi super app SDK (catch breaking change sớm khi SDK update)
- ✅ Self-documenting code — giảm thời gian onboard member mới
- ✅ IDE autocomplete + refactor an toàn (rename across files)
- ✅ Strict mode catch nhiều bug compile-time (null/undefined, exhaustive switch)
- ✅ Greenfield → cost adopt = 0
- ✅ Ecosystem RN + libraries (react-navigation, redux-toolkit, ...) đều ship .d.ts

**Cons:**
- ⚠️ Build time tăng (tsc step) — mitigate: skip emit, dùng SWC/Babel cho transform
- ⚠️ Member chưa quen TS cần thời gian học (~1-2 tuần ramp-up)
- ⚠️ Strict mode có thể frustrate khi prototype nhanh

### Option 2: TypeScript loose mode (no strict) ❌ LOẠI

**Diagram:**
```text
strict: false, noImplicitAny: false, allow any[]
```

**Lý do loại:**
- Cho phép `any` → mất hầu hết lợi ích type-safety
- Tạo "false sense of security" — code có types nhưng không enforced
- Migrate từ loose sang strict sau này tốn effort hơn adopt strict từ đầu

### Option 3: JavaScript + JSDoc ❌ LOẠI

**Diagram:**
```text
*.js + /** @type {...} */ comments  ──ts-check──►  type warnings
```

**Pros (cân nhắc):**
- Không cần build step transform
- Member không cần học cú pháp mới

**Lý do loại:**
- DX kém hơn TS thực thụ (verbose comments, IDE support yếu hơn)
- Refactor không an toàn bằng TS native
- Ecosystem RN ship .d.ts → JSDoc phải maintain riêng wrapper types
- Sau 6 tháng, codebase JSDoc sẽ drift khỏi reality

### Option 4: Plain JavaScript ❌ LOẠI

**Lý do loại:**
- Không có type-safety nào → super app SDK contract drift sẽ chỉ phát hiện ở runtime
- ADR-001 đã hint "đề xuất TS" — không có lý do mạnh để đảo
- Greenfield project, không có lý do legacy

## Consequences

### Positive
- ✅ Type-safe boundary với super app SDK (giảm production crash)
- ✅ Conventions trong `_context/conventions.md` được unblock (đang chờ ADR này)
- ✅ CI có thêm `npm run typecheck` step — catch bug sớm
- ✅ AI-assisted dev (Claude Code, Copilot) làm việc hiệu quả hơn với types

### Negative / Tradeoffs
- ⚠️ Build time tăng ~10-30% (cần benchmark cụ thể)
- ⚠️ Cần training cho member chưa rành TS strict
- ⚠️ Type definitions cho super app SDK có thể chưa đầy đủ → cần viết `.d.ts` riêng

### Đề xuất xử lý tradeoffs
- [DRAFT] Tạo `types/superapp.d.ts` wrap SDK với types đầy đủ (single source — như ADR-001 đã đề cập về `services/superApp/`)
- [DRAFT] Dùng SWC hoặc esbuild trong dev để skip type-check (chỉ check trong CI)
- [DRAFT] Workshop nội bộ 1 buổi về TS strict mode cho team

## Migration Plan

### Phase 1 — Setup (ngay khi merge ADR)
- [ ] Thêm `typescript` + `@types/react-native` vào package.json
- [ ] Tạo `tsconfig.json` với strict config (xem Decision)
- [ ] Thêm `npm run typecheck` script
- [ ] Thêm typecheck step vào CI (`.github/workflows/`)

### Phase 2 — Convention enforcement
- [ ] Update ESLint config: `@typescript-eslint/*` rules
- [ ] Update `_context/conventions.md`: bỏ "Sau khi có ADR-002" placeholder
- [ ] Update PR template tiny/normal/high-risk: thêm "typecheck pass" checkbox

### Phase 3 — Validate (sau 2 tuần)
- [ ] Đo build time impact
- [ ] Survey team về DX
- [ ] Adjust strict flags nếu friction quá cao

### Rollback plan
- Greenfield → rollback = đổi file `.ts(x)` → `.js(x)`, gỡ `tsconfig.json`, bỏ typecheck step CI.
- Cost rollback tăng theo thời gian (nhiều code TS-only patterns hơn → migrate khó hơn).
- **Trigger rollback** nếu: bundle size tăng >10% so với baseline, hoặc build time tăng >50%.

## Validation Metrics

- ✅ `tsc --noEmit` pass trong CI cho mọi PR
- ✅ Bundle size không tăng so với JS baseline (TS không emit runtime overhead)
- ✅ Build time tăng <30% so với JS baseline
- ✅ Số bug "type-related runtime error" trong 30 ngày đầu = 0
- ✅ Re-evaluate after: **3 tháng** kể từ ngày Active

## Open Questions

- [ ] TS version cụ thể? (gắn với RN version từ ADR-001)
- [ ] Dùng SWC, Babel hay tsc cho transform? (có thể tạo ADR riêng nếu phức tạp)
- [ ] Có cần `ts-pattern` hoặc `zod` cho runtime validation không? (cross với super app SDK boundary)

## Links

- Discussion: ADR-001:92 (referenced ADR-002 là follow-up)
- Related: [[ADR-001]] (RN framework), ADR-006 (testing — sẽ cần TS support cho Jest)
- Conventions: `_context/conventions.md:99` (TS strict config)
- Architecture: `_context/architecture.md:79` (TS strict mode section)

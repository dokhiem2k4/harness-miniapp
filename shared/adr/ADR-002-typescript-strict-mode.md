---
id: "ADR-002"
title: "Use TypeScript with strict mode for type safety"
date: 2026-05-27
deciders: ["@dokhiem2k4"]
status: "Active"
tags: [tech-stack, language, typescript]
---

# ADR-002: Use TypeScript with strict mode

## Status

**Active** — Quyết định ngày 2026-05-27, áp dụng từ đầu dự án.

## Context

Mini app sẽ có 8 fullstack dev làm song song trên nhiều feature. Codebase mới, chưa có legacy code.

Bài toán cần giải:
- Tránh runtime errors do type mismatch khi 8 người sửa code đan xen nhau
- Auto-complete tốt → onboarding nhanh hơn cho member mới
- Refactor an toàn khi đổi super app SDK signature
- Document API contracts qua types thay vì JSDoc comments

React Native runtime của Custom Super App hỗ trợ TypeScript out-of-the-box (đã verify).

## Decision

**Sử dụng TypeScript** với strict mode bật toàn bộ.

`tsconfig.json` config:

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "noImplicitOverride": true,
    "noFallthroughCasesInSwitch": true,
    "forceConsistentCasingInFileNames": true,
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "node",
    "jsx": "react-native",
    "lib": ["ES2022"],
    "esModuleInterop": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "allowSyntheticDefaultImports": true
  },
  "include": ["src/**/*", "tests/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

## Options Considered

### Option 1: TypeScript strict ✅ CHỌN

**Pros:**
- ✅ Type safety mạnh, catch lỗi compile-time
- ✅ Auto-complete tốt, IDE support đầy đủ
- ✅ Refactor an toàn (rename, find references chuẩn xác)
- ✅ Self-documenting code qua types
- ✅ Standard cho React Native modern projects
- ✅ Team 8 người làm song song → giảm conflict do type contracts rõ ràng

**Cons:**
- ⚠️ Learning curve cho member chưa quen TS (giảm thiểu qua pair programming)
- ⚠️ Build time tăng nhẹ (negligible với Metro cache)
- ⚠️ Phải maintain type definitions cho 3rd-party lib không có types

### Option 2: TypeScript loose (không strict) ❌ LOẠI

**Lý do loại:**
- Mất 70% benefit của TS (vẫn cho phép `any`, optional thiếu check)
- "Strict mode sau" thường không bao giờ xảy ra → tech debt
- Codebase greenfield → không có lý do compromise

### Option 3: JavaScript thuần ❌ LOẠI

**Lý do loại:**
- Team 8 người làm song song → cần type contracts
- PropTypes (alternative cũ) không catch lỗi compile-time
- Mất khả năng refactor an toàn

### Option 4: Flow ❌ LOẠI

**Lý do loại:**
- Facebook đã giảm đầu tư cho Flow
- Ecosystem RN dần chuyển hết sang TS
- Tooling support kém hơn TS

## Consequences

### Positive

- ✅ Catch type errors trước khi runtime
- ✅ Self-documenting code, đỡ phải đọc dài
- ✅ Onboard member mới nhanh hơn (IDE tự gợi ý)
- ✅ Wrapper cho super app SDK có type contract rõ ràng

### Negative / Tradeoffs

- ⚠️ Member chưa quen TS cần 1-2 tuần ramp up
- ⚠️ Một số RN lib cũ thiếu types → phải tự khai báo
- ⚠️ Strict mode có thể đôi lúc verbose (`noUncheckedIndexedAccess` ép check undefined nhiều)

### Đề xuất xử lý tradeoffs

- Buddy system: member quen TS pair với member mới trong tuần đầu
- Workspace shared `src/types/` chứa types cho 3rd-party lib thiếu định nghĩa
- KHÔNG dùng `@ts-ignore` — chỉ `@ts-expect-error` (tự fail khi error biến mất)
- KHÔNG dùng `any` — dùng `unknown` + type guards

## Open Questions

- [ ] ESLint config TypeScript-aware (sẽ làm trong setup tuần 1, không cần ADR riêng)
- [ ] Type generation cho API responses — có generate từ OpenAPI spec không? (ADR-008 nếu cần)

## Validation Metrics

- ✅ `npm run typecheck` pass với 0 errors
- ✅ KHÔNG có `any` trong production code (lint rule)
- ✅ Bundle size không tăng đáng kể so với JS (TS compile-only, không add runtime)

## Re-evaluate

- **After 3 tháng** — Survey team về DX, có pain point nào không
- **Trigger early** nếu RN runtime của super app drop TS support (rất unlikely)

## Links

- Related: ADR-001 (RN framework), ADR-006 (testing với TS)
- TypeScript docs: https://www.typescriptlang.org/tsconfig
- RN TypeScript guide: https://reactnative.dev/docs/typescript

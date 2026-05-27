---
id: "ADR-003"
title: "Use Zustand for cross-feature state, plain React for local state"
date: 2026-05-27
deciders: ["@dokhiem2k4"]
status: "Active"
tags: [tech-stack, state-management]
---

# ADR-003: Use Zustand for cross-feature state

## Status

**Active** — Quyết định ngày 2026-05-27, áp dụng từ đầu dự án.

## Context

Mini app sẽ có 2-3 feature chính với 8 fullstack dev làm song song. Cần quyết state strategy ngay từ đầu vì sai lầm ở đây tốn nhiều refactor sau:

- **Local state** (form input, modal open/close, screen-scoped UI flag) — không tranh cãi, dùng `useState` / `useReducer`.
- **Cross-feature state** (auth user, theme, cart count nếu có e-commerce, notification badge) — đây mới là vấn đề.

Constraints từ super app + team size ép thư viện state phải:
- **Bundle nhỏ** — super app có bundle size limit (TBD nhưng phải assume strict)
- **Không native module** — phải pure JS để chạy trong super app sandbox
- **Type-safe** — đã quyết TypeScript strict (ADR-002)
- **Learning curve thấp** — 8 dev, không phải ai cũng cùng background Redux/MobX

Đặc thù mini app này: scope chỉ 2-3 feature, không phải SaaS phức tạp. Over-engineering state ngay từ đầu sẽ tốn DX mãi mãi.

## Decision

**Sử dụng Zustand cho cross-feature/shared state.**

Layering rule:
1. **Local UI state** → `useState` / `useReducer` (không cần thư viện)
2. **Cross-feature state** → 1 Zustand store per feature (vd: `features/auth/store.ts`)
3. **Ambient context** (theme, i18n provider) → React Context — KHÔNG dùng Zustand vì Context phù hợp với "rarely-changing values"

Pattern example:

```typescript
// src/features/auth/store.ts
import { create } from 'zustand';

interface AuthState {
  user: User | null;
  setUser: (user: User | null) => void;
  clear: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  setUser: (user) => set({ user }),
  clear: () => set({ user: null }),
}));
```

Convention:
- 1 store per feature folder, file tên `store.ts`
- Store **không** gọi super app SDK trực tiếp — luôn qua wrapper trong `services/superApp/`
- Selector pattern khi consume: `const user = useAuthStore((s) => s.user)` thay vì destructure cả store (tránh re-render thừa)

## Options Considered

### Option 1: Zustand ✅ CHỌN

**Pros:**
- ✅ ~1.2KB minified+gzipped — gần như không impact bundle
- ✅ Pure JS, không native dep — compatible với super app sandbox
- ✅ Type inference tốt với `create<T>()` — không cần boilerplate types
- ✅ API 4-function (`create`, `set`, `get`, selectors) — learnable trong 1 buổi pair
- ✅ Không cần `<Provider>` wrap app — đỡ 1 layer wrapper hell
- ✅ Selector pattern built-in giúp tránh re-render không cần thiết
- ✅ Middleware tùy chọn (persist, devtools) — chỉ add khi cần

**Cons:**
- ⚠️ Yet another dep — Context + useReducer có thể đủ cho app nhỏ
- ⚠️ Không có convention chuẩn cho store shape — team phải tự thống nhất
- ⚠️ Ecosystem nhỏ hơn Redux (ít middleware, ít tutorial deep-dive)
- ⚠️ Selector boilerplate — dev quên dùng selector sẽ trigger re-render thừa

### Option 2: Context API + useReducer ❌ LOẠI

**Pros:**
- ✅ Zero dep
- ✅ Built-in React, mọi dev đều biết

**Cons / Lý do loại:**
- ⚠️ Re-render perf: mọi consumer re-render khi value đổi (trừ khi split context tinh vi)
- ⚠️ Verbose với cross-feature state (`createContext` + `Provider` + `useContext` + `useReducer` + `dispatch`)
- ⚠️ Type-safe nhưng phải khai báo nhiều generic
- ⚠️ Provider hell khi có nhiều context — phải nhớ wrap đúng thứ tự
- ⚠️ Test khó hơn (phải mock Provider tree)

→ Hợp lý cho ambient state (theme, locale) — đã đưa vào layering rule. KHÔNG hợp cho state thay đổi nhiều như user/cart.

### Option 3: Redux Toolkit ❌ LOẠI

**Pros:**
- ✅ Industry standard, mature ecosystem
- ✅ DevTools tốt nhất (time-travel debug)
- ✅ RTK Query cho async — opinionated, mạnh

**Cons / Lý do loại:**
- ⚠️ Bundle ~13KB cho `@reduxjs/toolkit` + ~8KB `react-redux` = ~21KB total (gzipped) — overkill cho mini app 2-3 feature
- ⚠️ Boilerplate cao: slice, reducer, action, store config, hooks typed
- ⚠️ Learning curve dốc với dev mới (action creators, middleware, RTK Query)
- ⚠️ Pattern nặng cho problem size — như dùng container ship để chở 3 kiện hàng

→ Sẽ phù hợp nếu app scale lên 10+ feature với complex async flows. Hiện tại chưa cần.

### Option 4: Jotai ❌ LOẠI

**Pros:**
- ✅ ~4KB, atom-based fine-grained reactivity
- ✅ TS-first design
- ✅ Tốt cho derived state phức tạp

**Cons / Lý do loại:**
- ⚠️ Atom mental model lạ với dev quen Flux/Redux — overhead onboarding
- ⚠️ Vẫn cần `<Provider>` (về kỹ thuật optional nhưng best practice là có)
- ⚠️ Debugging khó hơn — atom dependencies không hiển thị trực quan
- ⚠️ Ecosystem nhỏ hơn Zustand cho RN context

## Consequences

### Positive

- ✅ Bundle impact tối thiểu (~1.2KB)
- ✅ Onboarding dev mới nhanh (1 buổi pair là OK)
- ✅ Type-safe tự nhiên, không cần generic gymnastics
- ✅ Test dễ — store là plain JS object, có thể reset giữa các test
- ✅ Refactor an toàn khi đổi store shape (TS catch)

### Negative / Tradeoffs

- ⚠️ Convention phải tự định nghĩa — nếu không thống nhất, mỗi feature 1 kiểu store
- ⚠️ Dev quên dùng selector → re-render thừa, perf issue silently
- ⚠️ Không có "the right way" như Redux — junior có thể tạo store xấu (vd: nested state quá sâu)
- ⚠️ DevTools yếu hơn Redux DevTools — debug state flow phức tạp khó hơn

### Đề xuất xử lý tradeoffs

- **Convention guide** trong `_context/conventions.md` mục State (sẽ add trong PR follow-up):
  - 1 store per feature, file `store.ts`
  - Selector bắt buộc khi consume — lint rule custom nếu được
  - Flat state shape, không nested >2 level
  - Store actions là pure JS function, không side-effect trực tiếp (call SDK qua services/)
- **Code review checklist** thêm item: "Có dùng selector khi consume store không?"
- **Optional middleware** sau khi có bug: `zustand/middleware` cho devtools nếu cần debug

## Open Questions

- [ ] Có cần Redux DevTools-style time-travel debug không? (Zustand có `devtools` middleware, opt-in) → Quyết định trong sprint 3 nếu hit pain point.
- [ ] Persistence: state nào cần survive app restart? → Phụ thuộc super app storage API (xem `services/superApp/storage.ts` TODO). Hỏi `@2Tmy` khi có SDK doc.
- [ ] Convention 1-store-per-feature có cần exception cho global state (vd: theme)? → Đề xuất tạo `src/stores/theme.ts` outside features, lead `@dokhiem2k4` approve.
- [ ] Lint rule auto-detect "không dùng selector" — có khả thi với eslint-plugin-zustand không? → @hoangnxhust spike trong tuần 2.

## Validation Metrics

- ✅ Bundle size sau khi add Zustand tăng <2KB
- ✅ Time-to-first-state-change benchmark <50ms từ action → re-render
- ✅ Số file `useFeatureStore` import-and-destructure-without-selector = 0 (qua code review)
- ✅ Onboarding feedback từ 2 dev mới (sprint 3 survey): "Hiểu Zustand trong 1 buổi" — pass/fail

## Re-evaluate

- **After 3 tháng** — Survey team về DX. Nếu >30% phàn nàn về convention drift → cân nhắc strict scaffold tool.
- **Trigger early** nếu:
  - Bundle size budget vượt mà Zustand không phải primary contributor (chuyển sang vấn đề khác)
  - App scale lên >5 feature với async flows phức tạp → reconsider RTK Query
  - Performance issue do re-render dù đã dùng selector → debug deeper hoặc switch

## Links

- Related: ADR-001 (RN), ADR-002 (TS strict), ADR-005 (styling — theme có thể là Context không phải store)
- Zustand: https://github.com/pmndrs/zustand
- Comparison (Zustand vs Redux): https://docs.pmnd.rs/zustand/getting-started/comparison

---
id: "ADR-004"
title: "Use React Navigation for in-app routing"
date: 2026-05-27
deciders: ["@dokhiem2k4"]
status: "Active"
tags: [tech-stack, navigation]
---

# ADR-004: Use React Navigation for in-app routing

## Status

**Active** — Quyết định ngày 2026-05-27. Có thể revisit khi có chi tiết về super app navigation contract.

## Context

Mini app sẽ có 2-3 feature chính, mỗi feature có nhiều screen. Cần một thư viện navigation để:
- Quản lý stack screens trong từng feature
- Tab navigation giữa các feature chính (nếu có)
- Deep link từ super app → screen cụ thể của mini app
- Type-safe route params (vì đã quyết TypeScript ở ADR-002)

Super app sẽ provide entry point và có thể có deep link contract — sẽ cần wrapper để intercept.

## Decision

**Sử dụng React Navigation v6** (hoặc bản mới nhất stable tại thời điểm setup).

Pattern setup:
- `src/navigation/RootNavigator.tsx` — top-level navigator
- `src/navigation/types.ts` — typed route params cho từng screen
- Mỗi feature folder có thể có sub-navigator riêng (`features/[name]/Navigator.tsx`)
- Deep link handling qua `src/services/superApp/navigation.ts` wrapper

```typescript
// src/navigation/types.ts (example)
export type RootStackParamList = {
  Home: undefined;
  FeatureOneDetail: { id: string };
  FeatureTwoList: { filter?: string };
};

declare global {
  namespace ReactNavigation {
    interface RootParamList extends RootStackParamList {}
  }
}
```

## Options Considered

### Option 1: React Navigation ✅ CHỌN

**Pros:**
- ✅ De-facto standard cho RN navigation
- ✅ TypeScript support tốt (typed route params)
- ✅ Ecosystem lớn: stack, tab, drawer, modal đều có
- ✅ Deep linking built-in
- ✅ Active maintenance, đông community
- ✅ Team có khả năng đã quen (phổ biến)

**Cons:**
- ⚠️ Performance ở complex animation đôi khi không bằng native
- ⚠️ Setup ban đầu hơi verbose
- ⚠️ Có nhiều native dependencies (gesture-handler, reanimated, screens) — cần verify super app support

### Option 2: React Native Navigation (Wix) ❌ LOẠI

**Lý do loại:**
- Yêu cầu native module setup phức tạp → có thể conflict với super app sandbox
- Smaller community, ít update hơn
- Khó debug khi gặp lỗi native bridge

### Option 3: Tự build navigation đơn giản ❌ LOẠI

**Lý do loại:**
- Reinventing the wheel
- Mất ngày để có feature parity (back gesture, transitions, deep link)
- Team 8 người làm song song → cần convention chuẩn từ thư viện

### Option 4: Expo Router ❌ LOẠI

**Lý do loại:**
- Yêu cầu Expo Router runtime, không chắc super app support
- File-system routing nice nhưng over-kill cho mini app 2-3 feature
- Lock-in cao hơn so với React Navigation

## Consequences

### Positive

- ✅ Setup nhanh, có documentation tốt
- ✅ Type-safe navigation params (kết hợp ADR-002)
- ✅ Deep link integration đơn giản với super app
- ✅ Member mới quen ngay nếu đã làm RN

### Negative / Tradeoffs

- ⚠️ Cần native dependencies (gesture-handler, reanimated) — phải verify với super app team
- ⚠️ Một số animation phải custom nếu super app có design language riêng
- ⚠️ Phụ thuộc super app cho exit navigation (mini app không tự kill được)

### Đề xuất xử lý tradeoffs

- **CRITICAL: Verify super app support cho native deps** trước khi commit (hỏi super app team về `react-native-screens`, `react-native-gesture-handler`, `react-native-reanimated`)
- Wrap deep link handler trong `services/superApp/navigation.ts`
- Tránh custom animation phức tạp ở MVP — dùng default transitions

## Open Questions

- [ ] Super app có cho phép gesture-handler + reanimated native modules không? → BLOCK item
- [ ] Deep link format từ super app như nào? (URL scheme, intent, custom?)
- [ ] Exit mini app — gọi super app API hay back về root rồi super app tự đóng?

→ Note 3 câu hỏi này vào `_context/project-overview.md` mục Constraints để hỏi super app team.

## Validation Metrics

- ✅ Navigation giữa 2 screen mất <100ms
- ✅ Deep link mở đúng screen với params đúng (test e2e)
- ✅ Back gesture hoạt động trên cả iOS + Android
- ✅ Type errors compile-time nếu navigate với param sai

## Re-evaluate

- **Sau khi có super app SDK doc** — verify native deps OK
- **After 3 tháng** — Có pain point performance không
- **Trigger early** nếu super app navigation contract thay đổi

## Links

- Related: ADR-001 (RN), ADR-002 (TS), ADR-007 (bundler — Metro phải bundle native deps)
- React Navigation: https://reactnavigation.org

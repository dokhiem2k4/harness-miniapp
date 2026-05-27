---
id: "ADR-005"
title: "Use StyleSheet with centralized theme tokens for styling"
date: 2026-05-27
deciders: ["@dokhiem2k4"]
status: "Active"
tags: [tech-stack, styling, theme]
---

# ADR-005: Use StyleSheet + centralized theme tokens

## Status

**Active** — Quyết định ngày 2026-05-27, áp dụng từ đầu dự án. Sẽ revisit nếu có pain point lớn sau 3 tháng.

## Context

Mini app cần styling system cho 2-3 feature, 8 dev fullstack code song song. Yêu cầu:
- Consistency cross-feature (colors, spacing, typography) — không có chuyện mỗi screen 1 màu xanh khác nhau
- Type-safe (đã quyết TS strict ở ADR-002)
- Compatible với super app sandbox — đặc biệt **Babel config** dễ conflict nếu super app có pipeline build riêng
- Bundle size nhỏ — super app có limit (TBD)
- Dark mode khả thi (chưa biết PM có yêu cầu, nhưng nên không khoá cửa)

Constraint quan trọng: **Một số thư viện styling cần Babel plugin riêng** (NativeWind, styled-components optimization). Nếu super app build pipeline có quy ước riêng → conflict không trivial để debug.

## Decision

**Sử dụng React Native `StyleSheet.create()` + design tokens tập trung trong `src/theme/`.**

Theme structure:

```
src/theme/
├── colors.ts          ← Palette + semantic tokens
├── typography.ts      ← Font size, weight, line-height
├── spacing.ts         ← Spacing scale (4, 8, 12, 16, ...)
├── radius.ts          ← Border radius scale
├── shadow.ts          ← Shadow presets
└── index.ts           ← Re-export + ThemeContext nếu dark mode
```

Pattern usage:

```typescript
// src/theme/colors.ts
export const colors = {
  primary: '#0066FF',
  text: { primary: '#111', secondary: '#666' },
  background: '#FFF',
} as const;

// src/theme/spacing.ts
export const spacing = {
  xs: 4, sm: 8, md: 12, lg: 16, xl: 24, xxl: 32,
} as const;

// Component usage
import { StyleSheet } from 'react-native';
import { colors, spacing } from '@/theme';

const styles = StyleSheet.create({
  container: {
    backgroundColor: colors.background,
    padding: spacing.lg,
  },
  title: {
    color: colors.text.primary,
  },
});
```

Rule:
- KHÔNG hardcode color/spacing/font trong component — luôn import từ `theme/`
- KHÔNG dùng inline `style={{...}}` cho repeated patterns — chỉ cho dynamic 1-off
- Dark mode (nếu cần) dùng `useColorScheme()` + ThemeContext bao quanh tokens

## Options Considered

### Option 1: StyleSheet + theme tokens ✅ CHỌN

**Pros:**
- ✅ Zero dependency — chỉ dùng RN built-in
- ✅ KHÔNG cần Babel plugin → an toàn 100% với super app build pipeline
- ✅ Bundle impact = 0 (StyleSheet là native RN, theme tokens là plain JS object)
- ✅ Type-safe tự nhiên — tokens là `as const` TS literal types
- ✅ Performance tốt nhất — StyleSheet được RN optimize qua native bridge
- ✅ Dev nào biết RN cũng quen sẵn

**Cons:**
- ⚠️ Verbose hơn Tailwind utility classes (`padding: spacing.lg` vs `className="p-4"`)
- ⚠️ Không có responsive utilities sẵn — phải tự build qua `Dimensions` hoặc hooks
- ⚠️ Dark mode đòi hỏi setup ThemeContext + dynamic styles (không trivial nhưng làm được)
- ⚠️ Variant pattern (button size sm/md/lg) phải tự build qua function trả về StyleSheet

### Option 2: NativeWind (Tailwind) ❌ LOẠI

**Pros:**
- ✅ Tailwind syntax quen với dev đã làm web
- ✅ Utility-first → render code ngắn gọn
- ✅ Dark mode built-in qua `dark:` prefix
- ✅ Responsive utilities sẵn

**Cons / Lý do loại:**
- ❌ **Cần Babel plugin (`nativewind/babel`)** — RISK với super app sandbox nếu họ có Babel config riêng
- ⚠️ Bundle add ~10-15KB cho runtime + tokens
- ⚠️ TS support cần thêm plugin (`tailwindcss-classnames` hoặc tương tự)
- ⚠️ Class string không catch typo compile-time mặc định
- ⚠️ Phụ thuộc maintenance NativeWind (vẫn ổn nhưng smaller team than Tailwind core)

→ Nếu super app cho phép Babel plugin extension, reconsider sau 3 tháng.

### Option 3: styled-components ❌ LOẠI

**Pros:**
- ✅ CSS-in-JS, syntax quen
- ✅ Theme provider built-in
- ✅ Dynamic styles qua props

**Cons / Lý do loại:**
- ❌ Bundle ~12KB runtime — đáng kể cho mini app
- ⚠️ Runtime CSS generation — nhỏ nhưng có overhead
- ⚠️ Babel plugin (`babel-plugin-styled-components`) optional nhưng khuyến nghị cho SSR/optimization → vẫn risk
- ⚠️ TS types cho theme cần khai báo `DefaultTheme` interface — tốn boilerplate
- ⚠️ Performance kém hơn StyleSheet ở list dài (Flatlist) — RN benchmark show

### Option 4: restyle (Shopify) ❌ LOẠI

**Pros:**
- ✅ RN-first design (cùng team Shopify Polaris)
- ✅ Theme typed tự động
- ✅ Variant + responsive built-in
- ✅ KHÔNG cần Babel plugin

**Cons / Lý do loại:**
- ⚠️ Bundle ~5KB — không tệ nhưng vẫn lớn hơn 0
- ⚠️ API mới, learning curve (Box, Text, variants config)
- ⚠️ Lock-in với restyle component model
- ⚠️ Ecosystem nhỏ, ít examples cho edge cases

→ Đây là Option 1.5 — sẽ là backup nếu StyleSheet + theme thiếu structure quá. Chưa đủ lý do switch.

## Consequences

### Positive

- ✅ Build pipeline đơn giản nhất — không Babel plugin, không config phức tạp
- ✅ Bundle size budget gần như không bị ảnh hưởng bởi styling layer
- ✅ Performance tốt nhất cho list dài (FlatList với 100+ rows)
- ✅ Theme tokens là TS const → autocomplete + compile-time check tốt
- ✅ Dev nào cũng đọc/sửa được, không cần training

### Negative / Tradeoffs

- ⚠️ Code styling verbose hơn Tailwind — dev quen web có thể phàn nàn
- ⚠️ Responsive design phải tự build (`Dimensions` hoặc `useWindowDimensions` hook)
- ⚠️ Dark mode setup không trivial — cần ThemeContext + memoized styles
- ⚠️ Variant cho component (Button size, Card variant) phải code function
- ⚠️ Refactor theme (rename color) → grep + replace, không có "rename symbol" toàn cục như IDE rename

### Đề xuất xử lý tradeoffs

- **Helper hook** `useStyles(stylesFactory)` để memo styles theo theme khi dark mode bật
- **Convention** `Button.styles.ts` co-located — không scatter style trong file component
- **Lint rule** cấm hardcode hex color trong file ngoài `src/theme/` (regex check qua eslint custom rule, defer)
- **Spike** trong tuần 2: thử restyle với 1 component thực tế, so sánh DX → nếu pain point rõ rệt sẽ tạo ADR-005-supersede

## Open Questions

- [ ] Dark mode có nằm trong scope MVP không? → Hỏi PM trong tuần 1, ảnh hưởng architecture của theme layer.
- [ ] Design tokens lấy từ đâu? → Figma file location (TBD). Có thể tự sync manual hay cần auto-import qua Figma Tokens plugin? `@xwnsnowy` check Figma access.
- [ ] Responsive breakpoint convention — có cần không khi RN không có DOM media query? → Đề xuất defer cho đến khi có design phone landscape/tablet, lead approve.
- [ ] Variant pattern: function helper hay `cva`-like library (chỉ ~1KB)? → Đánh giá sau khi có 5+ component shared.

## Validation Metrics

- ✅ Bundle size delta từ styling layer = 0 (vì StyleSheet built-in)
- ✅ Lint check không có hardcode color/spacing ngoài `src/theme/` (CI rule, defer rule implementation 2 sprint)
- ✅ Dev mới (member tuần 1) build được 1 component theo theme trong <30 phút
- ✅ List 100 items với StyleSheet đạt 60fps (benchmark test)

## Re-evaluate

- **After 3 tháng** — Survey team:
  - "Bạn có thấy verbose lắm không?" — nếu >50% nói có → spike Tailwind/restyle
  - "Dark mode setup có pain không?" — nếu có và scope cần dark mode → reconsider restyle/styled-components
- **Trigger early** nếu:
  - Super app team confirm cho phép Babel plugin → NativeWind unlock, có thể switch
  - Performance issue ở FlatList do dynamic styles
  - Designer require utility-class workflow (unlikely cho mini app)

## Links

- Related: ADR-001 (RN), ADR-002 (TS strict — theme tokens typed), ADR-007 (Metro — Babel plugin nào cũng chạy qua Metro)
- React Native StyleSheet docs: https://reactnative.dev/docs/stylesheet
- Restyle (backup option): https://github.com/Shopify/restyle
- NativeWind (revisit nếu Babel plugin OK): https://www.nativewind.dev

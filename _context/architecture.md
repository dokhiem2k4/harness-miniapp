# Architecture — Nguyên tắc thiết kế

## 🏗️ High-level architecture

```text
┌─────────────────────────────────────────────────┐
│   Custom Super App (host)                       │
│                                                  │
│   ┌──────────────────────────────────────┐    │
│   │  harness-miniapp (this repo)         │    │
│   │                                        │    │
│   │  ┌────────────────────────────┐      │    │
│   │  │  React Native App           │      │    │
│   │  │  - Features                 │      │    │
│   │  │  - Components               │      │    │
│   │  │  - Services                 │      │    │
│   │  └────────────┬───────────────┘      │    │
│   │               │ uses                  │    │
│   │  ┌────────────▼───────────────┐      │    │
│   │  │  Super App SDK              │      │    │
│   │  │  - Auth                     │      │    │
│   │  │  - Payment                  │      │    │
│   │  │  - Storage                  │      │    │
│   │  │  - Navigation               │      │    │
│   │  └────────────┬───────────────┘      │    │
│   └───────────────┼─────────────────────┘    │
│                   │ provides                    │
│   ┌───────────────▼─────────────────────┐    │
│   │  Native bridges (iOS/Android)        │    │
│   └─────────────────────────────────────┘    │
└─────────────────────────────────────────────────┘

External services (mini app's own backend):
   - [Service 1 — vd: API server]
   - [Service 2 — vd: Analytics]
```

## 📐 Code architecture (đề xuất)

```text
src/
├── features/              ← Feature-first organization
│   ├── [feature-1]/
│   │   ├── screens/       ← Screens (pages)
│   │   ├── components/    ← Feature-specific components
│   │   ├── hooks/
│   │   ├── services/      ← API calls cho feature này
│   │   ├── types.ts
│   │   └── index.ts
│   └── [feature-2]/
│
├── components/            ← Shared UI components
│   ├── Button/
│   ├── Input/
│   └── ...
│
├── hooks/                 ← Shared hooks
│   ├── useAuth.ts
│   └── ...
│
├── services/              ← Cross-cutting services
│   ├── api/               ← API client setup
│   ├── superApp/          ← Super app SDK wrapper
│   ├── analytics/
│   └── storage/
│
├── navigation/            ← Navigation setup
│   ├── RootNavigator.tsx
│   └── types.ts
│
├── theme/                 ← Design tokens
│   ├── colors.ts
│   ├── typography.ts
│   └── spacing.ts
│
├── utils/                 ← Pure utility functions
│
└── types/                 ← Global TypeScript types
```

## 🎯 Nguyên tắc cốt lõi

### 1. Feature-first organization
Mỗi feature là 1 folder tự chứa, có thể di chuyển/xoá độc lập.

### 2. Super app SDK qua wrapper
KHÔNG gọi super app SDK trực tiếp từ components. Luôn qua `services/superApp/` wrapper.

**Lý do:** Nếu super app đổi SDK API → chỉ sửa wrapper, không phải cả codebase.

### 3. Composition over inheritance
React-style: components nhỏ, compose lại. KHÔNG class components.

### 4. TypeScript strict mode (sau khi có ADR-002)
```json
{
  "strict": true,
  "noUncheckedIndexedAccess": true,
  "exactOptionalPropertyTypes": true
}
```

### 5. Tests required cho logic
- Pure functions: 100% coverage
- Hooks: test happy path + edge cases
- Components: snapshot + interaction tests
- Skip: pure UI (style components)

### 6. Single source per concern

| Concern | Single source |
|---------|---------------|
| API calls | `services/api/` |
| Super app interaction | `services/superApp/` |
| Auth state | `hooks/useAuth.ts` |
| Theme | `theme/` |

## 🚫 Anti-patterns

- ❌ Direct super app SDK calls trong components
- ❌ Inline styles cho repeated patterns (dùng theme)
- ❌ `any` type (dùng `unknown` + type guards)
- ❌ Default exports cho components (named exports rõ ràng hơn)
- ❌ Logic phức tạp trong useEffect (move sang custom hook)
- ❌ Prop drilling >3 levels (dùng context hoặc state management)
- ❌ Inline async trong useEffect (dùng try/catch + cleanup)
- ❌ Hardcode strings (dùng i18n từ early stage)

## 🔐 Security & Privacy

> Cập nhật trong ADR riêng khi có quyết định.

### Data flow
- User data → super app cung cấp (auth token)
- Mini app store dữ liệu local? → ADR cần
- API calls có auth header? → ADR cần
- Sensitive data (payment, PII)? → ADR cần

## 📊 Performance budget

> Cập nhật khi có constraint từ super app.

| Metric | Budget |
|--------|--------|
| Bundle size | TBD |
| Cold start time | <2s target |
| API response time | <500ms p95 |
| Frame rate | 60fps trong scroll |

## 🔄 Cập nhật architecture

Đổi architecture = high-risk PR + ADR:

1. Tạo issue thảo luận
2. Có buy-in từ lead + 1 reviewer
3. Tạo ADR mô tả change
4. PR `high-risk/[change-slug]`
5. 2 reviewers approve

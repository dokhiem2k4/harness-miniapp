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
│   │  │  - Features (2-3 chính)     │      │    │
│   │  │  - Shared Components        │      │    │
│   │  │  - Services                 │      │    │
│   │  └────────────┬───────────────┘      │    │
│   │               │ uses                  │    │
│   │  ┌────────────▼───────────────┐      │    │
│   │  │  Super App SDK              │      │    │
│   │  │  - Auth (TBD - hỏi SA team) │      │    │
│   │  │  - Payment (nếu cần)        │      │    │
│   │  │  - Storage                  │      │    │
│   │  │  - Navigation (deep link)   │      │    │
│   │  └────────────┬───────────────┘      │    │
│   └───────────────┼─────────────────────┘    │
│                   │ provides                    │
│   ┌───────────────▼─────────────────────┐    │
│   │  Native bridges (iOS/Android)        │    │
│   │  (managed by super app, không tự    │    │
│   │   thêm native module được)          │    │
│   └─────────────────────────────────────┘    │
└─────────────────────────────────────────────────┘

External services (mini app's own backend):
   - [TBD - API server của mini app]
   - [TBD - Analytics nếu có]
```

## 📐 Code architecture

> Đã quyết: TypeScript + React Navigation + Metro bundler.
> State management, styling, testing → cần ADR-003, ADR-005, ADR-006.

```text
src/
├── features/              ← Feature-first organization
│   ├── [feature-1]/       ← TBD theo PM spec
│   │   ├── screens/       ← Screens (pages)
│   │   ├── components/    ← Feature-specific components
│   │   ├── hooks/
│   │   ├── services/      ← API calls cho feature này
│   │   ├── types.ts
│   │   └── index.ts
│   ├── [feature-2]/       ← TBD
│   └── [feature-3]/       ← TBD (optional)
│
├── components/            ← Shared UI components
│   ├── Button/
│   ├── Input/
│   └── ...
│
├── hooks/                 ← Shared hooks
│   ├── useAuth.ts         ← Wrap super app auth
│   └── ...
│
├── services/              ← Cross-cutting services
│   ├── api/               ← API client setup
│   ├── superApp/          ← ⭐ Super app SDK wrapper (CRITICAL)
│   ├── analytics/
│   └── storage/
│
├── navigation/            ← React Navigation setup
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
Mỗi feature là 1 folder tự chứa, có thể di chuyển/xoá độc lập. Tránh chia theo layer (controllers/, models/, views/) — khó scale với team 8 người làm song song.

### 2. Super app SDK qua wrapper (⭐ QUAN TRỌNG NHẤT)
**KHÔNG** gọi super app SDK trực tiếp từ components hoặc features. Luôn qua `src/services/superApp/`.

**Lý do:**
- Super app SDK có thể đổi API → chỉ sửa wrapper, không phải cả codebase
- Dễ mock cho testing
- Centralize error handling cho SDK failures
- Tracking SDK usage để biết feature nào phụ thuộc nhiều

**Pattern:**
```typescript
// ❌ KHÔNG làm thế này
import { SuperAppSDK } from '@superapp/sdk';
function MyScreen() {
  SuperAppSDK.auth.getUser();
}

// ✅ Làm thế này
import { useUser } from '@/services/superApp/auth';
function MyScreen() {
  const user = useUser();
}
```

### 3. Composition over inheritance
Functional components + hooks. KHÔNG class components.

### 4. TypeScript strict mode
Đã quyết dùng TypeScript. Tsconfig sẽ cần strict:

```json
{
  "strict": true,
  "noUncheckedIndexedAccess": true,
  "exactOptionalPropertyTypes": true
}
```

→ Detail trong ADR-002.

### 5. Tests required cho logic
- Pure functions: 100% coverage
- Hooks: test happy path + edge cases
- Components: snapshot + interaction tests
- Skip: pure UI (style components)

→ Test framework: cần ADR-006.

### 6. Single source per concern

| Concern | Single source |
|---------|---------------|
| API calls | `services/api/` |
| Super app interaction | `services/superApp/` |
| Auth state | `hooks/useAuth.ts` (wrap super app auth) |
| Theme | `theme/` |
| Navigation | `navigation/RootNavigator.tsx` |

## 🚫 Anti-patterns

- ❌ Direct super app SDK calls trong components (xem mục #2)
- ❌ Inline styles cho repeated patterns (dùng theme)
- ❌ `any` type (dùng `unknown` + type guards)
- ❌ Default exports cho components (named exports rõ ràng hơn cho team 8 người)
- ❌ Logic phức tạp trong useEffect (move sang custom hook)
- ❌ Prop drilling >3 levels (dùng context hoặc state management — ADR-003)
- ❌ Inline async trong useEffect (dùng try/catch + cleanup)
- ❌ Hardcode strings (dùng i18n từ early stage)
- ❌ Thêm native module mà không hỏi super app team trước

## 🔐 Security & Privacy

> ⚠️ Phụ thuộc constraints từ super app team. Update sau khi có spec.

### Data flow
- User data → super app cung cấp qua auth SDK
- Mini app store dữ liệu local? → **TBD: cần ADR + hỏi super app policy**
- API calls có auth header? → **TBD: token từ super app SDK**
- Sensitive data (payment, PII)? → **TBD: super app payment SDK nếu cần**

### Quy tắc tạm
- KHÔNG log token, password, PII
- KHÔNG store credit card info
- API calls qua HTTPS only
- Dependencies: check `npm audit` trước mỗi release

## 📊 Performance budget

> ⚠️ Bundle size limit là constraint quan trọng nhất. Hỏi super app team gấp.

| Metric | Budget |
|--------|--------|
| Bundle size | **TBD** (super app sẽ specify, thường 1-5MB) |
| Cold start time | <2s target |
| API response time | <500ms p95 |
| Frame rate | 60fps trong scroll |
| Memory peak | <150MB |

## 🔌 Super app integration points

> Các điểm cần hiểu rõ trước khi code:

| Integration | Mục đích | Wrapper location |
|-------------|----------|------------------|
| Auth | Lấy user info, token | `services/superApp/auth.ts` |
| Storage | Lưu key-value local | `services/superApp/storage.ts` |
| Navigation | Deep link, exit mini app | `services/superApp/navigation.ts` |
| Network | Gọi API qua super app proxy (nếu có) | `services/superApp/network.ts` |
| Permissions | Xin camera/location | `services/superApp/permissions.ts` |
| Lifecycle | Mini app start/pause/resume | `services/superApp/lifecycle.ts` |

**Tất cả wrapper trên đều TODO** — chỉ tạo khi đã có SDK doc thật.

## 🔄 Cập nhật architecture

Đổi architecture = high-risk PR + ADR:

1. Tạo issue thảo luận trên GitHub
2. Có buy-in từ team lead + 1 reviewer
3. Tạo ADR mô tả change trong `shared/adr/`
4. PR `high-risk/[change-slug]`
5. 2 reviewers approve (xem `CODEOWNERS`)

## 📋 ADR backlog (tech stack)

| ADR | Topic | Status | Owner |
|-----|-------|--------|-------|
| ADR-001 | React Native framework | ✅ Active | `@dokhiem2k4` |
| ADR-002 | TypeScript + tsconfig strict | ✅ Active | `@dokhiem2k4` |
| ADR-003 | State management (Redux/Zustand/Jotai) | 📝 TODO | TBD |
| ADR-004 | React Navigation setup pattern | ✅ Active | `@dokhiem2k4` |
| ADR-005 | Styling (StyleSheet/Tailwind/styled-components) | 📝 TODO | TBD |
| ADR-006 | Testing (Jest + RTL/Detox) | 📝 TODO | TBD |
| ADR-007 | Bundler (Metro vs Re.Pack) | ✅ Active (tentative) | `@dokhiem2k4` |
| ADR-008+ | TBD theo nhu cầu | — | — |

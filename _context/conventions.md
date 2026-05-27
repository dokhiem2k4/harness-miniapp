# Conventions — Mini App

> Code style + Git workflow.

## 🌳 Branch naming

```
[type]/[short-kebab-slug]
```

| Type | Cho gì | Ví dụ |
|------|--------|-------|
| `feature/` | Feature mới (normal) | `feature/payment-flow` |
| `fix/` | Bug fix (normal) | `fix/login-error-handling` |
| `tiny/` | Sửa nhỏ | `tiny/fix-typo-home` |
| `hotfix/` | Production hotfix | `hotfix/payment-crash` |
| `high-risk/` | Thay đổi lớn | `high-risk/migrate-to-rn-0.75` |
| `docs/` | Sửa docs | `docs/update-readme` |
| `chore/` | Maintenance | `chore/upgrade-deps` |
| `experiment/` | Spike (không merge) | `experiment/repack-evaluation` |

Slug: ≤50 chars, lowercase + dash.

## 💬 Commit messages

Conventional commits format:

```
[type]([scope]): [description]

[optional body]

[optional footer]
```

**Types:**
- `feat` — feature mới
- `fix` — bug fix
- `docs` — chỉ sửa docs
- `style` — formatting, không đổi logic
- `refactor` — refactor không thêm feature/fix
- `perf` — performance improvement
- `test` — thêm/sửa tests
- `chore` — build, deps, configs
- `ci` — CI/CD changes
- `tiny|normal|high-risk` — cho harness tasks

**Scopes (gợi ý):**
- `[feature-name]` — vd: `feat(payment): add stripe integration`
- `superapp` — super app integration changes
- `deps` — dependency updates
- `ci` — CI changes
- `harness` — harness changes

**Examples:**

```
feat(payment): add Stripe payment integration

Implements payment flow with Stripe Mobile SDK.
Handles success, failure, and timeout cases.

Closes #42
```

```
fix(auth): handle expired token correctly

Previously the app crashed when token expired.
Now redirects to super app login.
```

```
high-risk(superapp): migrate to new SDK v2

BREAKING CHANGE: Changes integration contract.
See ADR-007 for migration details.
```

## 📁 File naming

### Components
```
PascalCase/
├── PascalCase.tsx          ← Main component
├── PascalCase.test.tsx
├── PascalCase.styles.ts
└── index.ts                ← Re-export
```

Vd: `Button/Button.tsx`, `LoginScreen/LoginScreen.tsx`

### Hooks
```
camelCase.ts               ← bắt đầu với `use`
camelCase.test.ts
```

Vd: `useAuth.ts`, `usePayment.ts`

### Services / Utils
```
camelCase.ts
camelCase.test.ts
```

Vd: `apiClient.ts`, `formatCurrency.ts`

### Types
```
types.ts                   ← Trong cùng folder feature
```

Hoặc:
```
[domain].types.ts          ← Cho cross-feature types
```

## 🏷️ TypeScript

(Sau khi có ADR-002 xác nhận dùng TS — đề xuất default)

### Types vs Interfaces

- **`type`** cho unions, intersections, primitives
- **`interface`** cho object shapes (có thể extend)

### Naming

- `T` prefix cho generic: `function map<TItem>(items: TItem[])`
- `Props` suffix cho component props: `type ButtonProps = ...`
- `Response`, `Request` suffix cho API: `type LoginResponse = ...`

### Strictness

```json
{
  "strict": true,
  "noUncheckedIndexedAccess": true,
  "exactOptionalPropertyTypes": true,
  "noImplicitOverride": true
}
```

KHÔNG dùng `any`. Nếu thật sự cần → comment lý do.

## 🎨 Code style

### Imports order

```typescript
// 1. External
import React from 'react';
import { View } from 'react-native';

// 2. Super app SDK
import { SuperAppSDK } from '@super-app/sdk';

// 3. Internal absolute (từ src/)
import { Button } from 'components/Button';
import { useAuth } from 'hooks/useAuth';

// 4. Relative
import { styles } from './LoginScreen.styles';
import type { LoginScreenProps } from './types';
```

### Functions

```typescript
// Named exports
export function MyComponent(props: MyComponentProps) {
  // ...
}

// NOT default exports
export default function MyComponent() {} // ❌
```

### Hooks

```typescript
// Custom hook prefix với `use`
export function useFeature() {
  // ...
}
```

## 🧪 Testing

### Tests location
- Co-located với code: `Button.tsx` + `Button.test.tsx`
- Integration tests: `tests/integration/`
- E2E tests: `tests/e2e/`

### Naming
```typescript
describe('Button', () => {
  it('should render with primary variant', () => {});
  it('should call onPress when tapped', () => {});
});
```

### Coverage targets
- Pure utils: 90%+
- Hooks: 80%+
- Components: 60%+
- Overall: 70%+ minimum

## 🏷️ YAML Frontmatter (cho harness docs)

Tất cả file trong `shared/content/`, `shared/adr/`, `shared/retrospectives/` PHẢI có:

```yaml
---
title: "Tên"
author: "@dokhiem2k4"
created: 2026-05-27
status: draft | review | approved | deprecated
type: tiny | normal | high-risk
tags: [tag1, tag2]
notion_url: "https://notion.so/..."     # nếu là content/specs
linear_issue: "PROJ-123"                 # nếu link tới Linear
---
```

## 🔀 Merge strategy

- **Tiny PR**: Squash merge
- **Normal PR**: Squash merge
- **High-risk PR**: Squash merge (preserve PR body)

Auto-delete branch sau merge.

## ✅ Pre-commit checks

Local trước khi push:

```bash
npm run lint              # ESLint
npm run typecheck          # TypeScript
npm test                   # Tests
./scripts/pr-check.sh      # Harness validation
```

Hoặc dùng `/pr` trong Claude Code (tự chạy tất cả).

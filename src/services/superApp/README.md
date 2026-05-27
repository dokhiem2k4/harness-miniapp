# Super App SDK Wrappers

> ⚠️ Tất cả interaction với super app SDK PHẢI qua các file trong folder này.
> KHÔNG import super app SDK trực tiếp từ components/features.

## Files (TODO khi có SDK doc)

- `auth.ts` — Wrap super app auth (getUser, getToken, refreshToken)
- `storage.ts` — Wrap super app local storage
- `navigation.ts` — Deep link handling, exit mini app
- `network.ts` — API calls qua super app proxy (nếu super app yêu cầu)
- `permissions.ts` — Request camera/location/storage qua super app
- `lifecycle.ts` — Mini app start/pause/resume hooks
- `index.ts` — Re-export everything

## Pattern

Mỗi wrapper export hooks + utility functions, KHÔNG export SDK trực tiếp:

```typescript
// auth.ts (example - thật cần đợi SDK doc)
import { SuperAppSDK } from '@superapp/sdk';

export function useUser() {
  // implementation
}

export async function getAuthToken(): Promise<string> {
  // implementation
}

// ❌ KHÔNG làm: export { SuperAppSDK } — sẽ lộ SDK ra ngoài
```

## Reasoning

Xem ADR ở `shared/adr/`, mục Architecture > Super app SDK qua wrapper.

# Decisions Log

> Append-only. Format: xem `_meta/templates/decision-record.md`.
> ADRs chi tiết ở `shared/adr/`. File này tóm tắt + link.

---

## D-001: Sử dụng Harness GitHub Edition cho mini app

- **Date:** 2026-05-27
- **Deciders:** @team-lead
- **Status:** Active

### TL;DR
Dùng Harness GitHub Edition để quản lý code + technical decisions. Notion/Linear/Figma cho specs/tasks/design.

### Lý do
- Team đã quen Git workflow
- Cần audit trail cho decisions
- CI/CD validate được structure

### Tradeoff
- Setup ban đầu phức tạp hơn
- Cần training team về workflow

---

## D-002 → ADR-001: Sử dụng React Native

- **Date:** 2026-05-27
- **Deciders:** @team-lead
- **Status:** Active
- **Details:** Xem [ADR-001](./adr/ADR-001-react-native-framework.md)

### TL;DR
React Native — yêu cầu từ super app + cross-platform efficiency.

---

## Active ADRs

| ADR | Title | Status | Date |
|-----|-------|--------|------|
| [ADR-001](./adr/ADR-001-react-native-framework.md) | React Native framework | Active | 2026-05-27 |
| [ADR-002](./adr/ADR-002-typescript-strict-mode.md) | TypeScript with strict mode | Active | 2026-05-27 |
| [ADR-003](./adr/ADR-003-state-management.md) | State management (Zustand + Context) | Active | 2026-05-27 |
| [ADR-004](./adr/ADR-004-react-navigation.md) | React Navigation for in-app routing | Active | 2026-05-27 |
| [ADR-005](./adr/ADR-005-styling.md) | Styling (StyleSheet + theme tokens) | Active | 2026-05-27 |
| [ADR-006](./adr/ADR-006-testing.md) | Testing (Jest + RTL; E2E deferred to Maestro) | Active | 2026-05-27 |
| [ADR-007](./adr/ADR-007-metro-bundler.md) | Metro bundler (default RN) | Active (tentative) | 2026-05-27 |

## Open ADRs (cần làm)

- [ ] ADR-008: Super app native modules whitelist (chờ spec từ super app team)

## D-003: Unify decision.yaml schema with content frontmatter

- **Date:** 2026-05-27
- **Deciders:** @dokhiem2k4
- **Status:** Active
- **Related PR:** #2

### TL;DR
Cho phép `_meta/schemas/decision.yaml` accept thêm 3 fields optional (`author`, `created`, `type`) để cross-compat với `content.yaml` schema và `scripts/pr-check.sh` local check.

### Lý do
Khi `/intake` tạo ADR mới, `/pr` pre-flight check (theo content.yaml schema) auto-add 3 fields đó vào frontmatter. Nhưng CI `validate-schemas.yml` reject vì `decision.yaml` có `additionalProperties: false`.

→ Phát sinh drift: file ADR pass local pre-flight nhưng fail CI.

### Alternatives considered

#### Option A: Add 3 fields as optional vào decision.yaml ✅ CHỌN
- Pros: Backward compat với ADR-001, một schema duy nhất cho ADR
- Cons: Schema "loose" hơn (nhưng các fields vẫn validated nếu có)

#### Option B: Tách 2 schemas riêng (adr.yaml + decision-record.yaml) ❌ LOẠI
- Pros: Schema tách bạch rõ ràng
- Cons: Maintenance overhead, dễ drift, cần thay đổi nhiều workflows

#### Option C: Bỏ `pr-check.sh` strict check field author/created/type ❌ LOẠI
- Pros: Đơn giản hơn
- Cons: Mất lớp validation local, friction sẽ chỉ phát hiện qua CI (chậm)

### Consequences

- ✅ Local pre-flight và CI cùng accept ADR frontmatter
- ✅ ADR-002+ pass CI ngay
- ⚠️ Schema decision.yaml mở rộng (nhưng strict mode vẫn giữ với `additionalProperties: false`)

### When to revisit

- Nếu cần track schema ADR vs Decision Record khác nhau → cân nhắc Option B
- Sau 3 tháng nếu thấy việc field cross-compat gây confuse

---

## D-004: Per-path status enum + date normalization in CI workflows

- **Date:** 2026-05-27
- **Deciders:** @dokhiem2k4
- **Status:** Active
- **Related PR:** #3

### TL;DR
CI workflows `validate-frontmatter.yml` và `validate-schemas.yml` được sửa để:
1. Status enum check **per path** (ADR vs content có lifecycle khác nhau)
2. Normalize YAML date objects về string trước khi pass cho jsonschema

### Lý do
PR #1 (ADR-002) fail CI sau khi PR #2 (schema fix) merge vì 2 lý do:
1. ADR status `Proposed` không nằm trong content status enum hardcoded
2. YAML auto-parse `date: 2026-05-27` thành `datetime.date` object, không phải string

### Alternatives considered

#### Option A: Per-path enum + date normalize ✅ CHỌN
- Pros: Fix root cause, ADR và content có lifecycle riêng đúng nghĩa
- Cons: Workflow phức tạp hơn 1 chút

#### Option B: Force ADR users dùng quote string cho date ❌ LOẠI
- Pros: Đơn giản workflow
- Cons: Friction cho member, dễ quên quote, không scalable

#### Option C: Unified status enum (gộp ADR + content statuses) ❌ LOẠI
- Pros: Một enum duy nhất
- Cons: Confuse — `Active` cho ADR khác `approved` cho content semantically

### Consequences

- ✅ ADR và content có status lifecycle riêng, đúng nghĩa
- ✅ Workflow handle YAML date parsing automatically
- ✅ Member không cần nhớ quote date string
- ⚠️ Workflow script dài hơn (helper function)

### When to revisit

- Nếu thêm path mới (vd: `shared/specs/`) cần status enum riêng
- Sau 3 tháng nếu thấy edge case khác (timezone, datetime với time component)

---

## D-005 → ADR-002: TypeScript với strict mode

- **Date:** 2026-05-27
- **Deciders:** @dokhiem2k4
- **Lane:** high-risk
- **Status:** Active
- **Related ADR:** [ADR-002](./adr/ADR-002-typescript-strict-mode.md)
- **Related PR:** #4

### TL;DR
TypeScript bật toàn bộ strict flags (`noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitOverride`, ...) cho codebase greenfield. Mục tiêu: type safety cross-feature khi 8 dev làm song song, refactor an toàn khi super app SDK đổi signature.

---

## D-006 → ADR-003: State management — Zustand cho cross-feature state

- **Date:** 2026-05-27
- **Deciders:** @dokhiem2k4
- **Lane:** high-risk
- **Status:** Active
- **Related ADR:** [ADR-003](./adr/ADR-003-state-management.md)
- **Related PR:** #4

### TL;DR
Layering: local state qua `useState`/`useReducer`, cross-feature state qua Zustand (~1.2KB, no native dep), ambient providers qua React Context. Loại Redux Toolkit (overkill ~21KB), Jotai (atom model overhead), Context-only (re-render perf).

---

## D-007 → ADR-004: React Navigation cho in-app routing

- **Date:** 2026-05-27
- **Deciders:** @dokhiem2k4
- **Lane:** high-risk
- **Status:** Active
- **Related ADR:** [ADR-004](./adr/ADR-004-react-navigation.md)
- **Related PR:** #4

### TL;DR
React Navigation v6 với typed route params. Deep link qua `services/superApp/navigation.ts` wrapper. Native deps (gesture-handler, reanimated, screens) — BLOCKER cần verify với super app team.

---

## D-008 → ADR-005: Styling — StyleSheet + centralized theme tokens

- **Date:** 2026-05-27
- **Deciders:** @dokhiem2k4
- **Lane:** high-risk
- **Status:** Active
- **Related ADR:** [ADR-005](./adr/ADR-005-styling.md)
- **Related PR:** #4

### TL;DR
RN `StyleSheet.create()` + design tokens trong `src/theme/`. Zero dep, không Babel plugin → an toàn với super app sandbox. Loại NativeWind (cần Babel plugin), styled-components (~12KB runtime), restyle (~5KB, lock-in).

---

## D-009 → ADR-006: Testing — Jest + RTL (unit/integration); Maestro deferred (E2E)

- **Date:** 2026-05-27
- **Deciders:** @dokhiem2k4
- **Lane:** high-risk
- **Status:** Active
- **Related ADR:** [ADR-006](./adr/ADR-006-testing.md)
- **Related PR:** #4

### TL;DR
Tier 1 (active): Jest + `@testing-library/react-native` + `jest-native` matchers. Mock super app SDK ở `tests/mocks/superApp/`. Tier 2 (deferred): Maestro cho E2E khi có 2 feature complete. Loại Detox (cần modify app build, conflict super app sandbox).

---

## D-010 → ADR-007: Metro bundler (default RN)

- **Date:** 2026-05-27
- **Deciders:** @dokhiem2k4
- **Lane:** high-risk
- **Status:** Active (tentative)
- **Related ADR:** [ADR-007](./adr/ADR-007-metro-bundler.md)
- **Related PR:** #4

### TL;DR
Metro default với `blockList` cho `_context/`, `_meta/`, `shared/`, `.claude/`, `.github/`. Loại Re.Pack (setup phức tạp, team chưa có exp). Revisit nếu bundle vượt limit hoặc super app yêu cầu module federation.

---

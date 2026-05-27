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

## Open ADRs (cần làm)

- [ ] ADR-002: TypeScript or JavaScript
- [ ] ADR-003: State management
- [ ] ADR-004: Navigation
- [ ] ADR-005: Styling
- [ ] ADR-006: Testing
- [ ] ADR-007: Bundling
- [ ] ADR-008: Super app native modules whitelist

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

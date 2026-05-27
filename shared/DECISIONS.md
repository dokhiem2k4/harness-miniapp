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

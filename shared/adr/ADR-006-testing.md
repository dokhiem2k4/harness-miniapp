---
id: "ADR-006"
title: "Use Jest + React Native Testing Library; defer E2E to Maestro"
date: 2026-05-27
deciders: ["@dokhiem2k4"]
status: "Active"
tags: [tech-stack, testing]
---

# ADR-006: Testing — Jest + RTL for unit/integration; Maestro deferred for E2E

## Status

**Active** — Quyết định ngày 2026-05-27, áp dụng cho unit + integration test layer. E2E layer ở trạng thái **Deferred** — strategy documented nhưng không setup tooling đến khi có pain point thật.

## Context

Mini app cần test strategy cho:
1. **Unit + integration** — pure functions, hooks, components (chạy trong `npm test` mỗi PR)
2. **E2E** — user flow thật trên real device/sim (chạy mỗi release hoặc tuần)

Constraints:
- **CI integration** — test phải chạy trong GitHub Actions, không cần device
- **Super app sandbox** — E2E khó hơn vì mini app phải chạy trong super app host. Nếu super app team không cấp sandbox automation API → không thể run E2E truthful
- **Mock super app SDK** — mọi test phải mock `services/superApp/*` vì SDK không có trong unit test environment
- **Bundle size** — devDependencies không ảnh hưởng production bundle nhưng install size + CI duration thì có (8 dev x install time = đáng kể)
- **Type-safe** — test code cũng phải pass TS strict (ADR-002)

## Decision

### Tier 1: Unit + Integration — **Jest + React Native Testing Library** (active từ tuần 1)

Stack:
- `jest` + `@types/jest`
- `@testing-library/react-native` (RTL)
- `@testing-library/jest-native` (custom matchers như `toBeVisible`, `toBeDisabled`)
- `jest-expo` hoặc `react-native/jest-preset` cho RN setup
- Mock layer: `tests/mocks/superApp/` chứa fake implementations của `services/superApp/*` wrappers

Coverage targets (re-confirm `_context/conventions.md`):
- Pure utils: 90%+
- Hooks: 80%+
- Components: 60%+ (snapshot + key interaction)
- Overall: 70%+ minimum gate trong CI

### Tier 2: E2E — **Deferred to Maestro** (decision documented, setup later)

Khi nào trigger setup E2E:
- Sau khi có 2 feature complete và 1 critical user flow lock được spec
- Hoặc khi có production bug do regression không có test catch

Khi đó dùng **Maestro** (lý do trong Options Considered).

Không setup Detox.

## Options Considered

### Tier 1 options

#### Option 1.A: Jest + React Native Testing Library ✅ CHỌN

**Pros:**
- ✅ Jest là default trong React Native template — zero config thực sự
- ✅ RTL pattern (query by accessibility role) match a11y first principles
- ✅ TS support đầy đủ qua `@types/jest`
- ✅ Watch mode tốt, fast feedback dev loop
- ✅ Snapshot test built-in cho UI regression
- ✅ Mock module support mạnh — quan trọng để mock super app SDK

**Cons:**
- ⚠️ Jest config với RN preset đôi khi conflict với Metro transformer khi upgrade RN version
- ⚠️ `jest-native` matchers add ~50KB devDep — nhỏ nhưng đáng note
- ⚠️ RTL learning curve cho dev quen Enzyme (đã dying) hoặc shallow rendering
- ⚠️ Test runtime chậm hơn Vitest — nhưng Vitest không support RN tốt

#### Option 1.B: Vitest ❌ LOẠI

**Lý do loại:**
- Chưa có official RN support
- Phải custom config Metro/Babel pipeline → high risk
- Marginal speed benefit không đáng risk migration

### Tier 2 (E2E) options

#### Option 2.A: Maestro ✅ CHỌN (khi setup)

**Pros:**
- ✅ YAML flow definitions — dễ đọc, ai cũng viết được (kể cả QA không code)
- ✅ KHÔNG cần modify app build — chạy trên build production thực
- ✅ KHÔNG cần native module riêng — chỉ cần Maestro CLI + device/emulator
- ✅ Compatible với super app sandbox về nguyên tắc (chỉ tương tác qua UI level)
- ✅ Có Maestro Cloud cho CI mà không cần self-host device farm
- ✅ Setup nhanh — không cần Detox-style instrumentation build

**Cons:**
- ⚠️ YAML có thể verbose cho complex flows
- ⚠️ Test runtime chậm hơn unit test 10-100x (real device interaction)
- ⚠️ Flaky test nguy cơ cao (timing, network)
- ⚠️ Phụ thuộc super app provide sandbox + cách launch mini app — BLOCKER chưa giải

#### Option 2.B: Detox ❌ LOẠI

**Lý do loại:**
- ❌ Yêu cầu **modify app build** với instrumentation framework — risk lớn với super app sandbox (không tự control build pipeline)
- ❌ Native module setup phức tạp — iOS xcconfig, Android gradle changes
- ⚠️ Brittle ở RN upgrade — Detox lag sau mỗi RN major
- ⚠️ Community support đang giảm khi Maestro lên

### Tier 2 alternative: Defer hoàn toàn ❌ LOẠI

**Lý do KHÔNG defer hoàn toàn:**
- Phải có strategy document để team không "trôi" — defer nhưng có chiến lược khi cần
- Setup tooling later thì OK, nhưng câu hỏi "E2E làm bằng gì" phải trả lời sẵn

## Consequences

### Positive

- ✅ Tier 1 hoạt động từ ngày 1 — TDD có thể bắt đầu cho mọi feature
- ✅ Mock layer chuẩn cho super app SDK — feature dev không bị block bởi SDK chưa ready
- ✅ Defer E2E giảm setup cost ban đầu, không lãng phí thời gian setup Detox để rồi không dùng
- ✅ Maestro strategy được note rõ → team không phải research lại khi đến lúc

### Negative / Tradeoffs

- ⚠️ **Mock super app SDK = maintenance burden** — mỗi khi SDK real đổi signature, phải sync mock. Dễ drift.
- ⚠️ Không có E2E ngay → regression user flow phụ thuộc 100% vào manual QA trong sprint đầu
- ⚠️ Snapshot test có thể bị abuse — "snapshot updated, looks fine" thành thói quen → cần review checklist
- ⚠️ Coverage threshold 70% có thể ép test rác để pass threshold (test cho coverage thay vì test cho value)
- ⚠️ `jest-native` thêm dep, CI install time tăng ~5-10s
- ⚠️ Khi E2E unlock, có thể discover Maestro KHÔNG chạy được trong super app sandbox → fallback plan?

### Đề xuất xử lý tradeoffs

- **Mock SDK strategy**: `tests/mocks/superApp/*.ts` mirror exact signature của `services/superApp/*.ts`. TS sẽ catch drift. Lint rule cấm import mock vào production code.
- **Snapshot discipline**: PR review checklist add item "Snapshot updates đã verify visually chưa?" Reject auto-update không explain.
- **Coverage quality**: Coverage threshold là FLOOR, không phải target. Review checklist focus vào "test gì có ý nghĩa" thay vì "coverage có pass không".
- **E2E spike**: Khi đến lúc, dành 2 ngày spike Maestro với 1 flow đơn giản TRƯỚC khi commit full setup. Nếu super app sandbox không support → fallback manual + checklist.

## Open Questions

- [ ] Coverage 70% — đây là floor để pass CI hay aspirational target? → Đề xuất 70% là CI gate, 80%+ là aspirational. Lead `@dokhiem2k4` confirm.
- [ ] Mock super app SDK location — `tests/mocks/superApp/` hay `src/services/superApp/__mocks__/`? → Đề xuất `tests/mocks/` để keep production code clean, `@2Tmy` (CODEOWNERS của `services/superApp/`) decide.
- [ ] E2E trong CI — super app team có cấp sandbox để run automation không? → BLOCKER, hỏi super app team cùng đợt hỏi bundle size.
- [ ] Visual regression test có cần ngoài snapshot không? (Chromatic, Percy) → Defer, đánh giá sau khi có 5+ shared component.
- [ ] Component test với `react-test-renderer` deprecation roadmap — RTL có affected không? → `@hoangnxhust` track RN testing ecosystem, alert khi RN 0.76+ break thay đổi.

## Validation Metrics

- ✅ `npm test` chạy <60s ở local cho full suite (lúc đầu, monitor khi suite grow)
- ✅ Coverage report tạo được mỗi PR, threshold 70% gate
- ✅ Mỗi feature folder có ít nhất 1 test file trước khi merge
- ✅ Mock super app SDK có 100% signature match với real wrapper (TS check)
- ✅ Khi E2E setup (tương lai): Maestro flow test 1 critical user flow chạy trong CI <5min

## Re-evaluate

- **After 2 sprints (~4 tuần)** — Survey team:
  - "Test có giúp bạn confident merge không?" — nếu <60% yes → có thể test rác, audit
  - "Mock SDK có drift không?" — nếu có incident → cần auto-sync tool
- **Trigger E2E setup** khi:
  - Có 2 feature complete + 1 critical flow stable
  - Hoặc production bug do regression
- **Trigger early reconsider** nếu:
  - Jest + RTL có pain point lớn (perf, mock complexity) → cân nhắc Vitest khi RN support
  - Detox v20+ thật sự không cần custom build (unlikely) → reconsider

## Links

- Related: ADR-001 (RN), ADR-002 (TS strict — test code cũng strict), ADR-003 (state — store dễ test vì plain JS)
- Jest: https://jestjs.io
- React Native Testing Library: https://callstack.github.io/react-native-testing-library
- Maestro: https://maestro.mobile.dev
- Detox (rejected, kept for context): https://wix.github.io/Detox

---
id: "ADR-001"
title: "Use React Native for mini app implementation"
date: 2026-05-27
deciders: ["@dokhiem2k4"]
status: "Active"
tags: [tech-stack, framework]
---

# ADR-001: Use React Native for mini app implementation

## Status

**Active** — Quyết định ngày 2026-05-27, áp dụng từ đầu dự án.

## Context

Chúng ta đang xây dựng mini app cắm vào **Custom Super App** super app.

Super app team đã ra yêu cầu/khuyến nghị:
- Mini app phải chạy trên cả iOS và Android
- Super app cung cấp React Native runtime cho mini apps
- SDK của super app expose qua JavaScript bindings

Vì vậy lựa chọn framework không hoàn toàn mở — có constraint từ super app.

## Decision

**Sử dụng React Native** làm framework cho mini app.

Phiên bản: **React Native [VERSION]** (TBD — cần verify với super app team về version supported)

## Options Considered

### Option 1: React Native ✅ CHỌN

**Pros:**
- ✅ **Yêu cầu/khuyến nghị từ super app** — giảm friction integration
- ✅ Cross-platform (iOS + Android) từ 1 codebase
- ✅ Team có thể tận dụng React knowledge
- ✅ Ecosystem lớn (libraries, tooling)
- ✅ Hot reload tốt cho dev experience

**Cons:**
- ⚠️ Bundle size có thể lớn hơn native
- ⚠️ Native modules có thể bị giới hạn bởi super app
- ⚠️ Phụ thuộc vào RN version super app support

### Option 2: Flutter ❌ LOẠI

**Lý do loại:**
- Super app không support Flutter runtime
- Cần re-implement super app SDK bridge (rủi ro)
- Team không có Flutter experience

### Option 3: Native (Kotlin + Swift) ❌ LOẠI

**Lý do loại:**
- 2x effort (2 codebases)
- Super app architecture không thiết kế cho native mini apps
- Distribution flow phức tạp hơn (qua native app stores)

### Option 4: Hybrid web (WebView) ❌ LOẠI

**Lý do loại:**
- Performance kém hơn cho UX heavy
- Super app SDK access bị giới hạn trong WebView context
- Khó debug, không native-feel

## Consequences

### Positive

- ✅ Team productivity cao (1 codebase, hot reload)
- ✅ Integration với super app SDK seamless
- ✅ Distribution qua super app store, không qua Apple/Google store riêng

### Negative / Tradeoffs

- ⚠️ Bị lock-in vào React Native ecosystem
- ⚠️ Cần follow RN version super app support → không tự do upgrade
- ⚠️ Một số native features có thể không khả dụng

### Đề xuất xử lý tradeoffs

- Wrap super app SDK trong `services/superApp/` để có thể swap nếu cần
- Track RN version super app support — kiểm tra mỗi quarter
- Document native module restrictions trong ADR-008 (khi có)

## Open Questions (cần các ADR tiếp)

- [ ] **ADR-002**: TypeScript or JavaScript? (đề xuất TS)
- [ ] **ADR-003**: State management (Redux / Zustand / Context)?
- [ ] **ADR-004**: Navigation library?
- [ ] **ADR-005**: Styling approach (StyleSheet / styled-components / nativewind)?
- [ ] **ADR-006**: Testing framework (Jest + RNTL / Detox)?
- [ ] **ADR-007**: Bundling (Metro / Re.Pack với module federation)?
- [ ] **ADR-008**: Native modules whitelist từ super app?

## Migration Plan

N/A — Đây là quyết định ban đầu, không có migration.

## Validation Metrics

- ✅ Mini app build thành công với RN [version]
- ✅ Super app SDK integration test pass
- ✅ Bundle size dưới [LIMIT] MB

## Re-evaluate

- **After 6 tháng** — Đánh giá DX, performance, version compatibility
- **Trigger early** nếu super app thay đổi runtime/SDK contract

## Links

- Super app docs: [LINK]
- React Native version support: [LINK]
- Related: ADR-002 đến ADR-008 (sẽ làm trong tháng đầu)

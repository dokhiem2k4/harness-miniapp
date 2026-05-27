---
id: "ADR-007"
title: "Use Metro as bundler (default React Native bundler)"
date: 2026-05-27
deciders: ["@dokhiem2k4"]
status: "Active"
tags: [tech-stack, bundler, build]
revisit_after: "3 months"
---

# ADR-007: Use Metro as bundler

## Status

**Active (tentative)** — Quyết định ngày 2026-05-27. Có thể revisit khi:
- Có thông tin về super app bundle format (có dùng module federation không)
- Bundle size vượt limit và cần advanced code splitting

## Context

React Native cần JavaScript bundler để compile source → bundle distributable. 2 lựa chọn chính:
- **Metro** — default RN bundler, do Meta maintain
- **Re.Pack** — Webpack-based, hỗ trợ module federation (split bundle, lazy load)

Mini app sẽ cắm vào Custom Super App. Chưa rõ super app có yêu cầu format đặc biệt nào không (vd: chỉ accept Metro bundle, hay support module federation).

Team chưa có member nào có experience với Re.Pack ở production. Metro là default → setup zero-config.

## Decision

**Dùng Metro** (default RN bundler) cho initial setup.

`metro.config.js` cơ bản, không custom transformer trừ khi cần.

```javascript
// metro.config.js
const { getDefaultConfig } = require('@react-native/metro-config');

module.exports = {
  ...getDefaultConfig(__dirname),
  // Block các folder không phải code khỏi Metro scan
  resolver: {
    blockList: [
      /_context\/.*/,
      /_meta\/.*/,
      /shared\/.*/,
      /\.claude\/.*/,
      /\.github\/.*/,
    ],
  },
};
```

## Options Considered

### Option 1: Metro ✅ CHỌN

**Pros:**
- ✅ Default RN bundler — không cần setup phức tạp
- ✅ Maintained by Meta, đồng bộ với RN releases
- ✅ Team không cần learning curve
- ✅ Super app gần như chắc chắn support (vì là default)
- ✅ Đủ cho mini app 2-3 feature, bundle size dự kiến <5MB

**Cons:**
- ⚠️ KHÔNG hỗ trợ module federation (lazy load chunks)
- ⚠️ Tree-shaking yếu hơn Webpack
- ⚠️ Bundle size có thể lớn hơn với cùng codebase

### Option 2: Re.Pack ❌ LOẠI (tạm)

**Lý do loại:**
- Setup phức tạp hơn nhiều, team chưa có experience
- Module federation chỉ useful nếu mini app cực lớn (>10 feature) hoặc cần share runtime với super app
- Mini app 2-3 feature không cần advanced split
- Risk: nếu setup sai, bundle có thể không load được trong super app sandbox

**Khi nào revisit:**
- Bundle vượt limit của super app
- Super app team gợi ý module federation pattern
- Mini app scale lên >10 feature

### Option 3: esbuild / SWC custom setup ❌ LOẠI

**Lý do loại:**
- Không phải native RN bundler, cần custom integration
- Risk cao với super app sandbox compatibility
- Marginal benefit về tốc độ không đáng risk

## Consequences

### Positive

- ✅ Zero learning curve, dev có thể bắt đầu code ngay
- ✅ Compatibility với super app gần như 100%
- ✅ Hot reload tốt cho dev experience
- ✅ Setup ban đầu nhanh

### Negative / Tradeoffs

- ⚠️ Bundle size có thể không tối ưu — cần tree-shaking manual qua sized imports
- ⚠️ Không có code splitting → mọi feature đều trong cùng bundle
- ⚠️ Phải bundle size budget enforcement qua CI

### Đề xuất xử lý tradeoffs

- **CI check bundle size** sau mỗi build (đã có trong `.github/workflows/ci-build-miniapp.yml`)
- Dùng sized imports cho lib lớn (`import { specific } from 'lodash'` không phải `import _ from 'lodash'`)
- Tránh lib nặng nếu có pure-JS alternative (vd: `dayjs` thay `moment`)
- Monitor bundle size mỗi PR — warn nếu tăng >50KB

## Open Questions

- [ ] Super app team confirm: bundle format expected là gì? (single `.jsbundle`, hay split chunks?)
- [ ] Bundle size limit thực tế là bao nhiêu? → BLOCKER, hỏi super app
- [ ] Source maps có gửi cho super app cho crash reporting không?

## Validation Metrics

- ✅ Build production bundle thành công với `npm run build:miniapp`
- ✅ Bundle size <[limit từ super app] MB
- ✅ Cold start time <2s
- ✅ Bundle load thành công trong super app sandbox

## Re-evaluate

- **Sau khi có spec super app** — check format requirement
- **After 3 tháng** — đo bundle size, nếu gần limit thì cân nhắc Re.Pack
- **Trigger early** nếu super app team gợi ý module federation

## Links

- Related: ADR-001 (RN), ADR-002 (TS — Metro phải transform TS qua Babel)
- Metro docs: https://metrobundler.dev
- Re.Pack (cho trường hợp revisit): https://re-pack.dev

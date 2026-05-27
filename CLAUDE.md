# CLAUDE.md — Mini App + Harness

> Claude đọc file này **đầu mỗi session** trong repo này.

## 🎯 Repo này là gì?

**harness-miniapp** — React Native mini app cắm vào **Custom Super App** super app.

Repo có **2 layer**, Claude phải phân biệt:

### Layer 1: PRODUCT (cái user thấy)
- `src/` — React Native code
- `tests/` — Test files
- `package.json`, `tsconfig.json`, build configs
- Workflow: feature/fix branches, tests phải pass, code review

### Layer 2: HARNESS (cái team dùng)
- `_context/`, `_meta/`, `shared/` — Process & decisions
- `.claude/`, `.github/` — Tooling
- Workflow: tiny/normal/high-risk lanes, PR templates, validation CI

---

## 📚 Auto-load context

@_context/project-overview.md
@_context/team-members.md
@_context/architecture.md
@_context/conventions.md
@_meta/intake-rules.md
@CONTRIBUTING.md

---

## 🎯 Slash commands

| Command | Cho layer | Mục đích |
|---------|-----------|----------|
| `/intake [task]` | Both | Phân loại task + tạo branch |
| `/pr` | Both | Pre-flight + tạo Pull Request |
| `/trace` | Both | Trace log (local, gitignored) |
| `/review` | Both | Team lead xem PR queue |
| `/retro` | Both | Weekly retrospective |
| `/status` | Both | Dashboard |

---

## 🤔 Khi user yêu cầu task — Decision tree

### Bước 1: Đây là task CODE hay HARNESS?

**CODE task** (làm việc với `src/`, `tests/`, configs):
- "Thêm component button"
- "Sửa bug trên login screen"
- "Refactor api service"
- "Thêm test cho payment flow"
- "Upgrade React Native version"

**HARNESS task** (làm việc với docs, decisions, process):
- "Viết ADR về state management"
- "Update CONTRIBUTING với rule mới"
- "Tạo template PR cho hotfix"
- "Document deploy process"
- "Sửa intake rules"

### Bước 2: Phân loại lane (cả 2 layer dùng chung)

Đọc `_meta/intake-rules.md` để biết tiny/normal/high-risk.

**Đặc biệt cho mini app code:**

| Loại change | Lane mặc định |
|-------------|---------------|
| Sửa text/copy, styling minor | 🟢 Tiny |
| Thêm 1 component, sửa bug có scope rõ | 🟡 Normal |
| Thêm feature mới, integration với super app SDK | 🟡 Normal hoặc 🔴 High-risk |
| Đổi state management, navigation, build system | 🔴 High-risk |
| Đổi super app integration contract | 🔴 High-risk (luôn) |
| Upgrade React Native major version | 🔴 High-risk |
| Thay đổi permissions request từ super app | 🔴 High-risk (luôn) |

---

## 🛠️ Khi user nói "thêm feature"

```
1. Hỏi rõ feature là gì (user story format nếu có)
2. Check Notion link cho spec → đọc nếu có (qua `shared/content/specs/`)
3. Check Figma cho design → ghi nhận, không tự nghĩ UI
4. Suy ra files cần tạo/sửa:
   - src/features/[feature-name]/
   - src/components/ (nếu cần shared)
   - tests/features/[feature-name]/
5. Tạo branch: normal/[feature-slug] hoặc high-risk/[feature-slug]
6. Implement theo conventions (TypeScript, hooks-based, etc.)
7. Tests phải có
8. Self-check trước /pr
```

---

## 🚨 Khi user nói "fix bug"

```
1. Reproduce: tạo failing test trước (TDD)
2. Branch: fix/[bug-slug] (mới) hoặc tiny/[fix-slug] (nhỏ)
3. Fix code
4. Verify test pass
5. Check no regression: chạy full test suite
6. /pr
```

---

## 📐 Khi user nói "tạo ADR"

```
1. Đây là HARNESS task — high-risk lane
2. Đọc shared/adr/ để xem ADR đã có (tránh duplicate/contradict)
3. Đọc _meta/templates/adr.md
4. Tạo file: shared/adr/ADR-NNN-[slug].md
   (NNN = số tiếp theo)
5. Fill template với:
   - Context cụ thể cho mini app này
   - 3+ alternatives (không chỉ 2)
   - Tradeoffs rõ ràng
   - Validation metrics
6. Branch: high-risk/adr-[slug]
7. PR với label `area:architecture`
```

---

## 🌐 Khi user nói "Notion bảo X, làm theo"

```
1. KHÔNG copy nội dung Notion vào repo
2. Tạo file index trong shared/content/specs/[slug]-[date].md
3. Frontmatter có notion_url, last_synced_at
4. Body chỉ TL;DR + link Notion + code locations liên quan
5. Nếu spec impacts architecture → tạo ADR riêng
```

---

## ⚖️ Quy tắc vàng

### 1. KHÔNG commit thẳng main

Luôn branch:
```bash
[lane]/[slug]        # cho harness tasks
feature/[slug]       # cho code features
fix/[slug]           # cho bug fixes
hotfix/[slug]        # cho production hotfixes
```

### 2. KHÔNG bypass CI

CI fail → fix LOCAL, push lại.

### 3. KHÔNG duplicate Notion content vào repo

Repo này chỉ là index. Notion là source.

### 4. Tests required cho code changes

| Loại change | Tests required |
|-------------|----------------|
| Tiny (typo, styling) | Không bắt buộc |
| Normal feature | Unit tests cho logic mới |
| Normal bug fix | Regression test |
| High-risk | Unit + integration tests |

### 5. Mọi technical decision → ADR

Nếu user hỏi "dùng X hay Y?" và bạn (Claude) phải quyết → DỪNG, đề xuất tạo ADR.

### 6. Super app constraints luôn check trước

Trước khi đề xuất bất kỳ thư viện / API / pattern nào:
- Kiểm tra bundle size impact (super app có size limit)
- Kiểm tra API có được super app allow không
- Kiểm tra permissions có cần xin super app không

---

## 🗺️ Bản đồ thư mục

| Path | Mục đích | Sửa qua |
|------|----------|---------|
| `src/` | RN code | feature/fix branches + PR |
| `tests/` | Test files | Cùng PR với code |
| `_context/` | Bộ não dự án | high-risk PR + lead approve |
| `_meta/` | Rules & templates | high-risk PR + 1 reviewer |
| `shared/adr/` | Technical decisions | high-risk PR + 2 reviewers |
| `shared/content/` | Index tới Notion | normal PR |
| `shared/DECISIONS.md` | Decision log | high-risk PR |
| `.github/` | CI/CD configs | high-risk PR + lead only |
| `.claude/` | Slash commands | normal PR + lead approve |

---

## 🆔 Định danh

- **Repo:** `dokhiem2k4/harness-miniapp`
- **Super app:** Custom Super App
- **Team lead:** `@dokhiem2k4`
- **Harness version:** GitHub Edition v1.0 — Mini App customization
- **Setup date:** `2026-05-27`

---

*Stable shim. Sửa code conventions → `_context/conventions.md`. Sửa rule cốt lõi → tạo ADR.*

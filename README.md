# harness-miniapp — Mini App for Custom Super App

> React Native mini app embedded in Custom Super App super app.
> Repo này chứa **code**; docs/decisions/tasks ở Notion/Linear/Figma (link trong `shared/`).

---

## 🚀 Quick start

```bash
# Clone
git clone https://github.com/dokhiem2k4/harness-miniapp.git
cd harness-miniapp

# Install deps
npm install   # hoặc yarn / pnpm

# Run dev (cắm vào super app sandbox)
npm run dev   # TODO: script này cần add vào package.json khi có super app CLI

# Build production bundle
npm run build:miniapp   # TODO: script này cần add khi có super app spec
```

---

## 📐 Cấu trúc

```text
harness-miniapp/
│
│  ──────────── CODE ────────────
├── src/                       ← React Native code
│   ├── features/              ← Features chính (2-3, fill khi có spec)
│   ├── components/            ← Shared components
│   ├── hooks/
│   ├── services/              ← API calls, super app SDK wrapper
│   ├── navigation/            ← React Navigation setup
│   ├── theme/
│   ├── utils/
│   └── types/
├── tests/
├── package.json
├── tsconfig.json
├── babel.config.js
├── metro.config.js
│
│  ──────────── HARNESS ────────────
├── CLAUDE.md                  ← Cổng vào cho Claude Code
├── AGENTS.md                  ← Shim cross-agent
├── CONTRIBUTING.md            ← Git workflow cho team
├── CODEOWNERS                 ← Auto-assign reviewer (8 dev)
│
├── _context/                  ← Bộ não dự án
│   ├── project-overview.md
│   ├── team-members.md        ← 8 fullstack dev
│   ├── architecture.md        ← Sơ đồ + super app integration
│   ├── conventions.md         ← Code style + Git workflow
│   └── glossary.md
│
├── _meta/                     ← Rules
│   ├── intake-rules.md
│   ├── permissions.md
│   ├── validation-matrix.md
│   ├── schemas/               ← JSON schemas cho frontmatter
│   └── templates/             ← ADR, spec-index, story-packet templates
│
├── shared/                    ← Index tới sources of truth
│   ├── content/
│   │   ├── specs/             ← Link tới Notion specs
│   │   ├── design/            ← Link tới Figma
│   │   └── tasks/             ← Link tới Linear epic/issue
│   ├── adr/                   ← Technical decisions (GIỮ TRONG REPO)
│   ├── DECISIONS.md
│   ├── CHANGELOG.md
│   └── retrospectives/
│
│  ──────────── CI/CD ────────────
├── .github/
│   ├── workflows/
│   │   ├── ci-test.yml             ← Tests + lint code
│   │   ├── ci-build-miniapp.yml    ← Build mini app bundle
│   │   ├── validate-frontmatter.yml ← Harness docs validation
│   │   ├── validate-schemas.yml
│   │   ├── markdown-lint.yml
│   │   └── pr-labeler.yml
│   ├── ISSUE_TEMPLATE/
│   └── PULL_REQUEST_TEMPLATE/
│
└── .claude/
    └── commands/              ← 6 slash commands cho Claude Code
```

---

## 🏗️ Tech stack

| Layer            | Tech                       | Trạng thái            |
| ---------------- | -------------------------- | --------------------- |
| Framework        | **React Native**           | ✅ ADR-001 (Active)   |
| Language         | **TypeScript** (strict)    | ✅ ADR-002 (Active)   |
| Navigation       | **React Navigation**       | ✅ ADR-004 (Active)   |
| Bundling         | **Metro** (RN default)     | ✅ ADR-007 (tentative)|
| State management | TBD                        | 📝 ADR-003 cần làm    |
| Styling          | TBD                        | 📝 ADR-005 cần làm    |
| Testing          | TBD                        | 📝 ADR-006 cần làm    |

> **Mỗi ô "TBD" = 1 ADR cần làm trong tuần 1-2.** Xem [`shared/adr/`](shared/adr) để track.

---

## 🌐 Sources of Truth — Single source per category

Repo này **CHỈ chứa code + technical decisions**. Mọi thứ khác ở tool chuyên biệt:

| Loại thông tin                   | Nơi nó sống              | Lý do                               |
| -------------------------------- | ------------------------ | ----------------------------------- |
| 📋 **Code**                       | GitHub repo (này)        | Version control + CI/CD             |
| 🏗️ **Technical decisions (ADR)** | `shared/adr/` (repo này) | Gắn chặt với code                   |
| 📄 **Product specs**              | Notion                   | Format giàu, multi-stakeholder edit |
| 🎨 **Design / UX**                | Figma                    | Native tool cho design              |
| ✅ **Tasks / Sprints**            | Linear                   | Workflow tracking                   |
| 💬 **Discussion**                 | Slack                    | Real-time                           |


**Quy tắc:** `shared/content/specs/*.md` trong repo chỉ là **index** với link tới Notion + metadata. KHÔNG duplicate nội dung.

---

## 👥 Cho team mới (8 dev fullstack)

1. Đọc [`CONTRIBUTING.md`](CONTRIBUTING.md) — Git workflow
2. Đọc [`_context/project-overview.md`](_context/project-overview.md) — Mini app này làm gì
3. Đọc [`_context/architecture.md`](_context/architecture.md) — Super app integration patterns
4. Đọc [`shared/adr/`](shared/adr) — Các quyết định kỹ thuật đã có
5. Cài Claude Code: `curl -fsSL https://claude.ai/install.sh | sh`
6. Chạy `claude` trong repo → gõ `/status`
7. Pair với 1 member khác trong task đầu tiên

---

## 🔗 Links

> ⚠️ Cập nhật khi có workspace thực tế.

- **Notion workspace:** [TBD]
- **Linear project:** [TBD]
- **Figma:** [TBD]
- **Super app docs:** [TBD — hỏi super app team]
- **Slack channel:** `#TBD`

---

## 📋 Mini app constraints (từ super app)

> ⚠️ CRITICAL: Schedule call với super app team để fill bảng này tuần đầu.

- **Bundle size limit:** TBD MB
- **Allowed APIs:** TBD (xin whitelist)
- **Permissions model:** TBD
- **Distribution:** Internal review → super app
- **Update mechanism:** OTA / store (TBD)
- **Supported RN version:** TBD
- **Native modules cho phép:** TBD (mặc định KHÔNG)
- **Network policy:** TBD (whitelist domain?)

---

## 📅 Setup status

- **Phase:** 🌱 Greenfield setup
- **Repo init date:** 2026-05-27
- **Team size:** 8 fullstack dev (xem `_context/team-members.md`)
- **Next milestone:** Hoàn thành ADR-003, ADR-005, ADR-006 trong tuần 1-2

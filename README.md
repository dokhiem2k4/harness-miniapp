# harness-miniapp — Mini App for Custom Super App

> React Native mini app embedded in Custom Super App super app.
> Repo này chứa **code**; docs/decisions/tasks ở Notion/Linear/Figma (link trong `shared/`).

---

## 🚀 Quick start

```bash
# Clone
git clone https://github.com/[org]/[repo].git
cd [repo]

# Install deps
npm install   # hoặc yarn / pnpm

# Run dev (cắm vào super app sandbox)
npm run dev

# Build production bundle
npm run build:miniapp
```

---

## 📐 Cấu trúc

```text
[mini-app-name]/
│
│  ──────────── CODE ────────────
├── src/                       ← React Native code
│   ├── features/              ← Features chính, mỗi feature 1 folder
│   ├── components/            ← Shared components
│   ├── hooks/
│   ├── services/              ← API calls, super app SDK
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
├── CODEOWNERS                 ← Auto-assign reviewer
│
├── _context/                  ← Bộ não dự án
│   ├── project-overview.md    ← Mini app này là gì
│   ├── team-members.md
│   ├── architecture.md        ← Sơ đồ + super app integration
│   ├── conventions.md         ← Code style + Git workflow
│   └── glossary.md
│
├── _meta/                     ← Rules
│   ├── intake-rules.md
│   ├── permissions.md
│   ├── validation-matrix.md
│   └── templates/
│       └── adr.md
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

| Layer | Tech | Lý do |
|-------|------|-------|
| Framework | **React Native** | Super app yêu cầu — ADR-001 |
| Language | TBD | ADR-002 (đề xuất: TypeScript) |
| State management | TBD | ADR-003 |
| Navigation | TBD | ADR-004 |
| Styling | TBD | ADR-005 |
| Testing | TBD | ADR-006 |
| Bundling | TBD (Metro / Re.Pack) | ADR-007 |

> **Mỗi ô "TBD" = 1 ADR cần làm trong tháng đầu.** Xem [`shared/adr/`](./shared/adr/) để track.

---

## 🌐 Sources of Truth — Single source per category

Repo này **CHỈ chứa code + technical decisions**. Mọi thứ khác ở tool chuyên biệt:

| Loại thông tin | Nơi nó sống | Lý do |
|----------------|-------------|-------|
| 📋 **Code** | GitHub repo (này) | Version control + CI/CD |
| 🏗️ **Technical decisions (ADR)** | `shared/adr/` (repo này) | Gắn chặt với code |
| 📄 **Product specs** | Notion | Format giàu, multi-stakeholder edit |
| 🎨 **Design / UX** | Figma | Native tool cho design |
| ✅ **Tasks / Sprints** | Linear | Workflow tracking |
| 💬 **Discussion** | Slack | Real-time |

**Quy tắc:** `shared/content/specs/*.md` trong repo chỉ là **index** với link tới Notion + metadata. KHÔNG duplicate nội dung.

---

## 👥 Cho team mới

1. Đọc [`CONTRIBUTING.md`](./CONTRIBUTING.md) — Git workflow
2. Đọc [`_context/project-overview.md`](./_context/project-overview.md) — Mini app này làm gì
3. Đọc [`shared/adr/`](./shared/adr/) — Các quyết định kỹ thuật
4. Cài Claude Code: `curl -fsSL https://claude.ai/install.sh | sh`
5. Chạy `claude` trong repo → gõ `/status`

---

## 🔗 Links

- **Notion workspace:** [LINK]
- **Linear project:** [LINK]
- **Figma:** [LINK]
- **Super app docs:** [LINK]
- **Slack channel:** [#mini-app-dev]

---

## 📋 Mini app constraints (từ super app)

> Cập nhật khi nhận được spec từ super app team.

- **Bundle size limit:** TBD MB
- **Allowed APIs:** TBD
- **Permissions model:** TBD
- **Distribution:** Internal review → super app
- **Update mechanism:** OTA / store
- **Supported RN version:** TBD
- **Native modules cho phép:** TBD

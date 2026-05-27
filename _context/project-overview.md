# Project Overview — harness-miniapp

> Claude đọc file này để hiểu dự án.

## Một dòng tóm tắt

**harness-miniapp** là **mini app cắm vào Custom Super App** giúp người dùng **[problem nó giải quyết]**.

## Bối cảnh

- **Loại sản phẩm:** Mini app (React Native, embedded trong super app)
- **Super app host:** Custom Super App
- **Đối tượng người dùng:** Users của Custom Super App
- **Phase hiện tại:** 🌱 Greenfield — đang setup

## Mục tiêu chính

1. [Mục tiêu 1 — vd: "Cho phép user X làm Y trong N bước"]
2. [Mục tiêu 2]
3. [Mục tiêu 3]

## Phạm vi

### Trong scope
- [Feature 1]
- [Feature 2]
- Integration với super app SDK ([list APIs])

### Ngoài scope (KHÔNG làm)
- Standalone app (chỉ chạy trong super app)
- [Feature không làm 1]
- [Feature không làm 2]

## Constraints từ super app

> Cập nhật khi nhận được tài liệu từ super app team.

| Constraint | Giá trị | Ảnh hưởng |
|------------|---------|-----------|
| Bundle size max | TBD | Cần tree-shaking, lazy load |
| Allowed APIs | TBD | Có thể không dùng được lib X |
| Native modules | TBD | Có thể cần workaround |
| Permissions | TBD | Cần request qua super app |
| Network policy | TBD | API endpoints whitelist? |
| Update mechanism | OTA / store | Ảnh hưởng release flow |

## Stakeholders

- **Product owner:** [Tên hoặc team]
- **Super app team:** [Liên hệ]
- **Mini app team lead:** `@dokhiem2k4`
- **Designers:** [Tên — Figma]
- **PMs:** [Tên — Notion + Linear]

## Sources of truth (theo loại thông tin)

| Loại | Nơi |
|------|-----|
| 📋 Tasks, sprints, backlog | [Linear](https://linear.app/...) |
| 📄 Product specs, PRDs | [Notion](https://notion.so/...) |
| 🎨 Designs, UX flows | [Figma](https://figma.com/...) |
| 🏗️ Code | Repo này |
| 🧬 Technical decisions | `shared/adr/` (repo này) |
| 💬 Daily discussion | Slack: `#[channel]` |

## Trạng thái hiện tại

- **Phase:** Greenfield setup
- **Sprint hiện tại:** N/A (chưa bắt đầu)
- **Milestone gần nhất:** MVP — [target date]
- **Repo init date:** [YYYY-MM-DD]

## Đường roadmap (high-level)

| Phase | Mục tiêu | Target |
|-------|----------|--------|
| 0. Setup | Repo + harness + tech stack ADRs | Week 1-2 |
| 1. Foundation | Auth + navigation + super app integration | Week 3-4 |
| 2. MVP features | Core features list | Week 5-8 |
| 3. Polish | UI/UX iteration, performance | Week 9-10 |
| 4. Launch | Submit lên super app review | Week 11-12 |

## Repo

- **GitHub URL:** https://github.com/[org]/[repo]
- **Default branch:** main
- **License:** [chọn license — Apache 2.0, MIT, hoặc Proprietary]

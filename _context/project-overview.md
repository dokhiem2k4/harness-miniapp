# Project Overview — harness-miniapp

> Claude đọc file này để hiểu dự án.
> File này là "bộ não" — fill kỹ ngay từ đầu, đừng để TBD quá 1 tháng.

## Một dòng tóm tắt

**harness-miniapp** là mini app React Native cắm vào **Custom Super App**, cung cấp 2-3 feature chính cho user của super app.

> 📝 **TODO khi đã có spec từ PM:** Viết lại 1 câu cụ thể.
> Format: "Mini app giúp [đối tượng user] làm [hành động] để [đạt mục tiêu]."

## Bối cảnh

- **Loại sản phẩm:** Mini app (React Native, embedded trong super app)
- **Super app host:** Custom Super App
- **Đối tượng người dùng:** Users của Custom Super App
- **Phase hiện tại:** 🌱 Greenfield — đang setup harness + tech stack

## Mục tiêu chính

> 📝 **TODO:** Fill 2-3 feature chính sau khi có spec từ PM/Notion.

1. [Feature 1 — TBD: hỏi PM/đọc Notion spec]
2. [Feature 2 — TBD]
3. [Feature 3 — TBD, nếu có]

## Phạm vi

### Trong scope
- 2-3 feature chính (sẽ fill cụ thể khi có spec)
- Integration với super app SDK (auth, navigation, storage — chi tiết ở `architecture.md`)
- Internal release qua Custom Super App distribution channel

### Ngoài scope (KHÔNG làm)
- Standalone app (chỉ chạy trong super app)
- Push notification độc lập (dùng super app's notification system)
- In-app payment ngoài super app payment SDK
- Web version

## Constraints từ super app

> ⚠️ **CRITICAL:** Đây là phần cần đi hỏi super app team SỚM NHẤT.
> Mọi tech decision (ADR-002 → ADR-007) đều phụ thuộc bảng này.

| Constraint | Giá trị | Ảnh hưởng |
|------------|---------|-----------|
| Bundle size max | **TBD** — hỏi super app team | Quyết định có dùng được lib nặng như Lottie, moment.js không |
| Allowed APIs | **TBD** — xin whitelist | Một số RN built-in module có thể bị chặn |
| Native modules | **TBD** — có cho phép custom native module không? | Nếu KHÔNG → phải tìm pure-JS alternative |
| Permissions | **TBD** — model permission của super app | Camera/location/storage đều phải xin qua super app |
| Network policy | **TBD** — có whitelist domain backend không? | API endpoints có thể cần đăng ký trước |
| Update mechanism | **TBD** — OTA hay store-only? | Quyết định release cadence |
| RN version | **TBD** — super app support version nào? | Phải match đúng, không tự upgrade được |
| TypeScript support | ✅ Có (super app RN runtime hỗ trợ) | Đã quyết → ADR-002 |

**Action items để fill bảng này:**
- [ ] Schedule call với Custom Super App platform team
- [ ] Yêu cầu document: SDK reference, allowed APIs list, size budget
- [ ] Yêu cầu access vào super app sandbox để test
- [ ] Note câu trả lời vào `shared/content/specs/superapp-constraints-[YYYY-MM-DD].md`

## Stakeholders

> 📝 **TODO:** Fill khi xác định được team.

- **Product owner:** [TBD — tên hoặc team]
- **Super app team contact:** [TBD — quan trọng nhất, là người trả lời câu hỏi ở bảng Constraints]
- **Mini app team lead:** `@dokhiem2k4`
- **Designers:** [TBD — tên + Figma file link]
- **PMs:** [TBD — Notion workspace owner]

## Sources of truth (theo loại thông tin)

| Loại | Nơi |
|------|-----|
| 📋 Tasks, sprints, backlog | [Linear](https://linear.app/TBD) |
| 📄 Product specs, PRDs | [Notion](https://notion.so/TBD) |
| 🎨 Designs, UX flows | [Figma](https://figma.com/TBD) |
| 🏗️ Code | Repo này (`src/`) |
| 🧬 Technical decisions | `shared/adr/` (repo này) |
| 💬 Daily discussion | Slack: `#TBD-channel-name` |

## Trạng thái hiện tại

- **Phase:** Greenfield setup
- **Sprint hiện tại:** N/A (chưa bắt đầu)
- **Milestone gần nhất:** Setup tech stack + 6 ADR (target: hết tuần 2)
- **Repo init date:** 2026-05-27

## Đường roadmap (high-level)

| Phase | Mục tiêu | Target |
|-------|----------|--------|
| 0. Setup | Repo + harness + tech stack ADRs (ADR-002 → ADR-007) | Tuần 1-2 |
| 1. Foundation | Super app integration layer + navigation skeleton | Tuần 3-4 |
| 2. Feature 1 | [TBD theo PM] | Tuần 5-6 |
| 3. Feature 2 | [TBD theo PM] | Tuần 7-8 |
| 4. Polish + Feature 3 | UI/UX iteration, performance, optional 3rd feature | Tuần 9-10 |
| 5. Launch | Submit lên super app review | Tuần 11-12 |

## Repo

- **GitHub URL:** https://github.com/dokhiem2k4/harness-miniapp
- **Default branch:** main
- **License:** [TBD — chọn license + thêm `LICENSE` file]

---

## Checklist setup ban đầu

- [ ] Fill mục "Một dòng tóm tắt" (sau khi có spec)
- [ ] Fill 2-3 feature ở "Mục tiêu chính"
- [ ] Fill bảng "Constraints từ super app" (BLOCKER cho mọi ADR)
- [ ] Fill "Stakeholders"
- [ ] Update các link trong "Sources of truth"
- [ ] Tạo ADR-003, ADR-005, ADR-006 (state, styling, testing)

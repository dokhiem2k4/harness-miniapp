# Team Members

> Mapping GitHub username → role.
> Khi member join/leave → update file này VÀ `CODEOWNERS` cùng lúc.

## Team Lead

| GitHub username | Vai trò |
|-----------------|---------|
| `@dokhiem2k4` | Team lead, review, approve, merge |

## Members (8 người — tất cả Fullstack Dev)

| GitHub username | Vai trò |
|-----------------|---------|
| `@2Tmy` | Fullstack Dev |
| `@hoangnxhust` | Fullstack Dev |
| `@mvhoang92` | Fullstack Dev |
| `@kawaii-bunny` | Fullstack Dev |
| `@Minhle1212` | Fullstack Dev |
| `@xwnsnowy` | Fullstack Dev |
| `@dokhiem2k4` | Fullstack Dev + Team lead |
| `@Jmhzbmcn2` | Fullstack Dev |

## Reviewers (cho high-risk PR)

> High-risk PR cần ít nhất 2 approver. Vì tất cả đều fullstack dev, bất kỳ ai cũng có thể review.
> Convention: team lead `@dokhiem2k4` luôn là 1 trong 2 reviewer cho high-risk.

**Tất cả 8 member đều có quyền review high-risk PR.**

Default reviewers (qua CODEOWNERS rule `*`):
- `@dokhiem2k4` (team lead)
- `@Jmhzbmcn2` (co-owner default rule — auto-assigned cho mọi PR chưa có area-specific owner)

Round-robin gợi ý để tránh dồn review lên 1 người:
- Author chọn 2 reviewer ngoài chính mình
- Ưu tiên người có context với area đang sửa (xem CODEOWNERS)

## Quy ước

- GitHub username trong `CODEOWNERS` **phải match** file này (case-sensitive)
- Khi member join/leave → cập nhật **đồng thời**:
  1. File này (`_context/team-members.md`)
  2. `CODEOWNERS`
  3. Notion/Linear team page (nếu có)
- Username case-sensitive — `@2Tmy` ≠ `@2tmy`

## Onboarding checklist (cho member mới)

- [ ] Tạo PR `chore/onboard-[username]` thêm tên vào file này + `CODEOWNERS`
- [ ] Add vào GitHub repo với quyền Write (team lead approve)
- [ ] Đọc `CONTRIBUTING.md` + `_context/conventions.md` + `_context/architecture.md`
- [ ] Đọc tất cả ADR trong `shared/adr/`
- [ ] Cài Claude Code, chạy `/status` để verify setup
- [ ] Pair với 1 member khác trong 1 task đầu tiên

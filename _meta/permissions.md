# Permissions — GitHub Edition

> Trong GitHub workflow, permissions được enforce qua:
> 1. **CODEOWNERS** — auto-assign reviewer
> 2. **Branch protection** — require approvals
> 3. **GitHub roles** — repo collaborator levels

Không cần permission matrix thủ công như Syncthing edition.

## Setup Branch Protection (Team Lead làm 1 lần)

### Main branch rules

`Settings → Branches → Add rule` cho `main`:

- [x] Require a pull request before merging
  - [x] Require approvals: **1** (Normal) / **2** (High-risk)
  - [x] Dismiss stale approvals when new commits pushed
  - [x] Require review from Code Owners
- [x] Require status checks to pass
  - [x] Require branches to be up to date
  - Status checks:
    - `Validate Frontmatter`
    - `Validate Schemas`
    - `Markdown Lint`
    - `Auto-label PR`
- [x] Require linear history
- [x] Require conversation resolution before merging
- [x] Restrict who can push to matching branches
  - Add team-lead only
- [x] Do not allow bypassing the above settings (đối với Admin)

### Differential rules cho high-risk paths

Tạo thêm rule cho path `shared/adr/*`:
- Require **2** approvals

## CODEOWNERS

Xem file `CODEOWNERS` ở root repo.

Behavior:
- File trong `shared/content/` → @team-lead auto-assigned
- File trong `shared/adr/` → @team-lead + @reviewer-1 + @reviewer-2
- File trong `_meta/` → @team-lead + @reviewer-1
- File trong `.github/` → chỉ @team-lead

## Role-based access

### GitHub repo roles

Trong `Settings → Manage access`:

| GitHub role | Cho ai | Có thể |
|-------------|--------|--------|
| **Admin** | Team Lead | All (settings, branch protection, etc.) |
| **Maintain** | Reviewers (optional) | Manage issues/PRs, no settings |
| **Write** | All members | Push branches, create PRs |
| **Read** | External | Clone, view |

### Khuyến nghị

- Team Lead: 1 người, Admin
- Reviewers: 2-3 người, Maintain (cho high-risk PRs)
- Members: còn lại, Write

## Quy trình "nâng quyền tạm thời"

Member cần làm việc lấn vào file của reviewer/lead?

1. Mở issue: `gh issue create --template proposal.yml`
2. Tag `permission-request`
3. Team lead approve trong issue → tạm thêm member vào CODEOWNERS
4. PR merged → revert CODEOWNERS

## Audit

- Mọi merge vào main có signature trong git log
- CODEOWNERS history qua `git log --follow CODEOWNERS`
- Branch protection events trong `Settings → Audit log`

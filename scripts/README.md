# Scripts — CLI helpers cho Harness GitHub Edition

> Bash scripts hỗ trợ workflow Git. Chạy local trên máy member.
>
> Logic chính giờ ở **slash commands** (`.claude/commands/`) khi dùng Claude Code.
> 2 script ở đây là **fallback** khi không có Claude — hoặc khi muốn dùng trong CI/automation.

## 📜 Scripts có sẵn

### `new-branch.sh` — Tạo branch đúng convention

**Mục đích:** Validate slug + tự pull main + tạo branch với prefix đúng.

**Usage:**
```bash
./scripts/new-branch.sh [lane] [slug]
```

**Examples:**
```bash
# Tiny task
./scripts/new-branch.sh tiny fix-typo-pho-article

# Normal task
./scripts/new-branch.sh normal article-banh-mi

# High-risk task
./scripts/new-branch.sh high-risk restructure-content-folder
```

**Validate:**
- Lane phải là 1 trong: `tiny`, `normal`, `high-risk`, `docs`, `chore`, `experiment`
- Slug: lowercase + dash, no underscore/dấu, ≤50 ký tự
- Tự `git checkout main && git pull` trước khi tạo branch

**Tương đương với `/intake` trong Claude:**
- `/intake` thông minh hơn: tự hỏi 8 risk flags để quyết lane
- `new-branch.sh` rẻ hơn: nếu bạn đã biết lane, gõ 1 lệnh là xong

---

### `pr-check.sh` — Pre-flight validation trước khi mở PR

**Mục đích:** Chạy local validation trước khi push, tránh fail CI rồi mới sửa.

**Usage:**
```bash
./scripts/pr-check.sh
```

**Validate 8 thứ:**

| # | Check | Block hay warn |
|---|-------|----------------|
| 1 | Branch không phải `main` | ❌ Block |
| 2 | Branch name đúng convention | ❌ Block |
| 3 | Không có uncommitted changes | ❌ Block |
| 4 | Có ít nhất 1 commit ahead of main | ❌ Block |
| 5 | Commit messages conventional format | ⚠️ Warn |
| 6 | Frontmatter đầy đủ trong `shared/` files | ❌ Block |
| 7 | High-risk PR có Decision Record | ❌ Block |
| 8 | File naming đúng convention | ❌ Block |

**Exit code:**
- `0` → tất cả pass, sẵn sàng `gh pr create`
- `1` → có lỗi, fix rồi chạy lại

**Tương đương trong Claude:**
- `/pr` tự chạy `pr-check.sh` đầu tiên rồi mới tạo PR
- Chạy `pr-check.sh` thủ công khi không dùng Claude Code

---

## 🤔 Khi nào dùng script vs slash command?

| Tình huống | Dùng | Lý do |
|-----------|------|-------|
| Member dùng Claude Code hằng ngày | Slash command (`/intake`, `/pr`) | Smart, có context |
| Member quen Git, không muốn mở Claude | Script | Nhanh, 1 lệnh |
| CI/automation cần validate | Script | Có exit code, machine-friendly |
| Onboarding member mới | Cả 2 | Script để hiểu rule, slash command để work fast |

---

## 🛠️ Yêu cầu hệ thống

- **Bash 4+** (macOS có thể cần `brew install bash`)
- **Git 2.x+**
- **(Optional) GitHub CLI `gh`** — chỉ cần cho workflow PR

Windows: dùng Git Bash hoặc WSL.

---

## 🚀 Mở rộng

Muốn thêm script mới? Quy trình:

1. Tạo file trong `scripts/[ten].sh`
2. Đặt shebang: `#!/usr/bin/env bash`
3. `chmod +x scripts/[ten].sh`
4. Update README này
5. Mở PR với label `area:scripts`

**Ý tưởng scripts thêm:**
- `update-changelog.sh` — Auto-append CHANGELOG từ git log
- `check-stale-prs.sh` — Liệt kê PR đợi >3 ngày
- `archive-old-content.sh` — Move content cũ sang `shared/archive/`
- `count-friction.sh` — Đếm friction issues theo tuần

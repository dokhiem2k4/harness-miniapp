# 🤝 Contributing — Workflow cho team

> Tài liệu này dành cho **mọi member**. Đọc 1 lần, dùng được mãi.

---

## ⚡ TL;DR (cho người vội)

```bash
# 1. Sync với main
git checkout main && git pull

# 2. Tạo branch
git checkout -b normal/your-task-name

# 3. Mở Claude Code và intake task
claude
> /intake "Mô tả task của bạn"

# 4. Làm việc + commit
git add . && git commit -m "normal: short description"

# 5. Push và mở PR
git push origin normal/your-task-name
gh pr create  # hoặc dùng /pr trong Claude

# 6. Đợi CI pass + team lead review

# 7. Approve → merge → branch tự xoá
```

---

## 📋 Một lần setup (cho member mới)

### Yêu cầu

- [ ] Git đã cài (`git --version` chạy được)
- [ ] GitHub account có quyền clone repo
- [ ] (Optional) GitHub CLI `gh` — rất tiện cho workflow này
- [ ] Claude Code: `curl -fsSL https://claude.ai/install.sh | sh`

### Clone repo

```bash
git clone https://github.com/[org]/[repo].git
cd [repo]
```

### Cài GitHub CLI (khuyến nghị)

```bash
# macOS
brew install gh

# Linux
sudo apt install gh   # hoặc xem https://cli.github.com

# Windows
winget install GitHub.cli
```

Sau đó:

```bash
gh auth login
```

### Test setup

```bash
claude
# Trong Claude:
> /status
```

Nếu Claude trả lời được tình trạng team → setup OK 🎉

---

## 🎯 Workflow chi tiết cho từng loại task

### 🟢 Tiny task — Sửa nhỏ (5-30 phút)

**Khi nào dùng**: Sửa typo, format, link hỏng, thêm 1-2 dòng vào file đã có.

```bash
# 1. Pull main mới nhất
git checkout main && git pull

# 2. Tạo branch với prefix tiny/
git checkout -b tiny/fix-typo-pho-article

# 3. Sửa file
# (mở editor, sửa)

# 4. Commit
git add .
git commit -m "tiny: fix typo in pho article"

# 5. Push
git push -u origin tiny/fix-typo-pho-article

# 6. Mở PR (GitHub CLI)
gh pr create --template tiny.md

# 7. Đợi CI + lead approve → merge
```

**PR template tiny** (tự fill khi `gh pr create --template tiny.md`):

```markdown
## 🟢 Tiny Change

**What**: [1 câu]
**Why**: [1 câu]
**File(s) changed**: [list]

- [ ] Self-checked
- [ ] No breaking change
```

---

### 🟡 Normal task — Content mới hoặc sửa lớn (1-3 ngày)

**Khi nào dùng**: Viết bài mới, tạo doc, spec, hoặc thay đổi đáng kể.

```bash
# 1. Pull main
git checkout main && git pull

# 2. (Optional) Tạo issue trước để track
gh issue create --template proposal.yml

# 3. Tạo branch với prefix normal/
git checkout -b normal/article-banh-mi

# 4. Mở Claude và intake
claude
> /intake "Viết bài về bánh mì Việt Nam"

# Claude sẽ:
# - Hỏi 8 risk flags
# - Phân loại normal
# - Tạo file shared/content/articles/banh-mi-YYYY-MM-DD.md với frontmatter sẵn

# 5. Làm việc với Claude (vài giờ - vài ngày)

# 6. Commit nhiều lần cho rõ tiến độ
git add shared/content/articles/banh-mi-2026-05-27.md
git commit -m "normal: draft banh mi article structure"

git add shared/content/articles/banh-mi-2026-05-27.md
git commit -m "normal: add history section"

# 7. Khi xong, push
git push -u origin normal/article-banh-mi

# 8. Mở PR (Claude giúp fill template)
> /pr

# 9. CI tự chạy:
# ✅ Frontmatter valid
# ✅ Schema valid
# ✅ Markdown lint
# Nếu fail → đọc log, fix, push lại

# 10. CODEOWNERS auto-assign team lead
# 11. Team lead review trên GitHub UI
# 12. Có thể: needs revision (member fix) → request changes → push → re-review
# 13. Approve → merge → branch auto-delete
```

---

### 🔴 High-risk task — Thay đổi lớn (3-14 ngày)

**Khi nào dùng**: Multi-file, structural change, đề xuất sửa convention, hoặc bất kỳ thay đổi nào khó hoàn tác.

**BẮT BUỘC** trước khi làm:

```bash
# 1. Tạo issue thảo luận TRƯỚC
gh issue create --template proposal.yml --title "[HIGH-RISK] Restructure content folder"
```

Trong issue: mô tả ý tưởng, đợi team lead + ít nhất 1 reviewer comment đồng ý direction.

**Sau khi có buy-in:**

```bash
# 2. Pull main, tạo branch
git checkout main && git pull
git checkout -b high-risk/restructure-content-folder

# 3. Mở Claude + intake
claude
> /intake "Restructure shared/content/ — gom theo topic thay vì date"

# Claude phân loại high-risk, tạo story packet:
# .work/story-S-NNN/
#   ├── overview.md
#   ├── design.md
#   ├── execplan.md
#   └── validation.md

# 4. Discuss tiếp trong issue, refine design

# 5. Implement theo execplan
# Commit thường xuyên

# 6. Push branch
git push -u origin high-risk/restructure-content-folder

# 7. Mở PR
> /pr   # Claude fill template high-risk.md

# 8. PR sẽ require:
# - CI pass
# - 2 reviewers approve (CODEOWNERS rule cho high-risk)
# - Decision Record D-NNN trong shared/DECISIONS.md
# - (Nếu kiến trúc) ADR trong shared/adr/

# 9. Có thể họp team 30 phút trước approve

# 10. Approve → merge
```

---

## 🌳 Branch naming convention

```
[lane]/[short-kebab-case-slug]
```

| Prefix | Khi nào | Ví dụ |
|--------|---------|-------|
| `tiny/` | Sửa nhỏ | `tiny/fix-broken-link-home` |
| `normal/` | Content/feature thường | `normal/add-article-banh-mi` |
| `high-risk/` | Thay đổi lớn | `high-risk/restructure-folders` |
| `docs/` | Sửa docs (không phải content) | `docs/update-readme` |
| `chore/` | Maintenance | `chore/upgrade-ci-actions` |
| `experiment/` | Thử nghiệm (không merge) | `experiment/new-template-format` |

**Slug rules:**
- Tối đa 50 ký tự
- Lowercase + dash, không underscore
- Mô tả ngắn gọn task, không có ngày tháng (đã có trong commit history)

---

## 💬 Conventional commits

Format:
```
[type]: [short description in present tense]

[optional body — what & why, not how]

[optional footer — Closes #N]
```

**Types**:
- `tiny`, `normal`, `high-risk` (cho content task)
- `feat`, `fix`, `docs`, `chore`, `refactor` (cho code task)

**Ví dụ tốt:**
```
normal: add article about banh mi Vietnamese cuisine

Article covers history, regional variations, and modern adaptations.
Sources cited from culinary research databases.
Self-checklist completed before submission.

Closes #42
```

**Ví dụ KHÔNG tốt:**
```
update          ❌ (không có type, không mô tả)
fix stuff       ❌ (mơ hồ)
WIP             ❌ (đừng push WIP commits)
```

---

## ✅ Trước khi mở PR — Pre-flight checklist

Chạy local:

```bash
# 1. Self-check
./scripts/pr-check.sh
# Script này check: frontmatter, naming convention, schema

# 2. Markdown lint local (optional)
npx markdownlint-cli2 "**/*.md"

# 3. Verify diff đúng ý
git diff main...HEAD

# 4. Đảm bảo commit message conventional
git log main..HEAD --oneline
```

Tick checklist trong PR template trước khi submit.

---

## 🔍 Đọc CI logs khi fail

CI fail là **bình thường** — đừng panic. Đọc log để biết fix gì:

```bash
# Xem CI status PR hiện tại
gh pr checks

# Xem log workflow failed
gh run view --log-failed
```

Common failures:

| CI fail | Lỗi thật | Cách fix |
|---------|----------|----------|
| `frontmatter validation` | Thiếu field `author` hoặc `created` | Add vào YAML frontmatter |
| `schema validation` | Field sai type (vd: `created: "today"` thay vì date) | Đổi format `YYYY-MM-DD` |
| `markdown lint` | Heading skip cấp, link broken | Đọc log chi tiết |
| `file naming` | File không theo convention | Rename file |

---

## 🆘 Issues thường gặp

### "Tôi commit vào main rồi"

```bash
# Backup commit
git log --oneline -5   # ghi nhớ commit hash

# Reset main về origin
git checkout main
git reset --hard origin/main

# Tạo branch và cherry-pick commit
git checkout -b normal/my-task
git cherry-pick [commit-hash]

# Push branch
git push -u origin normal/my-task
```

### "Branch của tôi conflict với main"

```bash
# Pull main mới
git checkout main && git pull

# Rebase branch lên main
git checkout normal/my-task
git rebase main

# Resolve conflicts trong editor (Claude có thể giúp)
# Sau khi resolve:
git add .
git rebase --continue

# Force push (cẩn thận — chỉ nếu branch của bạn không ai khác dùng)
git push --force-with-lease
```

### "Tôi muốn close PR mà không merge"

```bash
gh pr close [PR-num] --comment "Đổi hướng tiếp cận, sẽ mở PR mới"
```

### "PR đợi review lâu quá"

- Gửi reminder trong Slack/Discord team
- Hoặc comment trong PR mention `@team-lead`
- Lưu ý: high-risk PR sẽ đợi lâu hơn vì cần 2 reviewers

---

## 📊 Metrics team theo dõi

Bạn có thể tự check qua GitHub:

```bash
# PR của bạn tuần này
gh pr list --author "@me" --state all

# Issues bạn đang assign
gh issue list --assignee "@me"

# Friction issues của team
gh issue list --label friction
```

---

## 📚 Đọc tiếp khi cần

- `CLAUDE.md` — Cách Claude làm việc trong repo
- `_meta/intake-rules.md` — Chi tiết 3 lanes phân loại
- `_meta/permissions.md` + `CODEOWNERS` — Ai sửa được gì
- `_meta/validation-matrix.md` — Validation cho từng loại output
- `.github/PULL_REQUEST_TEMPLATE/` — Các template PR

---

## 💡 Best practices

1. **Pull main mỗi sáng** — tránh conflict
2. **Branch nhỏ, PR nhỏ** — dễ review hơn 1 PR khổng lồ
3. **Commit thường xuyên** — không đợi xong 100% mới commit
4. **CI fail → fix local** trước khi push lại — không spam CI runs
5. **Đọc PR template** kỹ — đừng để trống section nào
6. **Self-review trước** — đọc lại diff như reviewer trước khi request review
7. **Đừng force-merge** — CI fail có lý do
8. **Friction → issue, không workaround** — ghi vào GitHub issue với label `friction`

---

*Có câu hỏi? Mở issue với label `question` hoặc ping team lead.*

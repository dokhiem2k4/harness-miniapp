<!--
  Đây là PR template mặc định.
  Để dùng template phù hợp với lane của bạn, mở PR với param `?template=`:
  - ?template=tiny.md
  - ?template=normal.md
  - ?template=high-risk.md

  Hoặc dùng GitHub CLI:
  gh pr create --template tiny.md
-->

## 🎯 What

<!-- Mô tả ngắn (1-2 câu): bạn đang làm gì? -->


## 💡 Why

<!-- Tại sao thay đổi này cần thiết? Link issue nếu có. -->

Closes #


## 📋 Lane

<!-- Chọn 1 -->

- [ ] 🟢 Tiny — sửa nhỏ, không ảnh hưởng người khác
- [ ] 🟡 Normal — content/feature mới
- [ ] 🔴 High-risk — multi-file, structural, hoặc đề xuất thay đổi convention


## ✅ Checklist

- [ ] Branch name follows convention `[lane]/[slug]`
- [ ] Commit messages follow conventional format
- [ ] Frontmatter completed cho mọi file content
- [ ] Self-checked qua `./scripts/pr-check.sh`
- [ ] (Nếu high-risk) Decision Record added in `shared/DECISIONS.md` or `shared/adr/`
- [ ] (Nếu sửa convention) Tag `area:meta` được apply


## 🧪 Validation

<!-- Làm sao team biết PR này work? -->

How to verify:
1.
2.


## ❓ Questions for reviewer

<!-- Có gì bạn không chắc và muốn reviewer xem kỹ? -->

1.
2.


## 📸 Screenshots / examples (optional)

<!-- Nếu liên quan UI/visual -->

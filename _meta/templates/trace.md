---
date: YYYY-MM-DD
user: "@dokhiem2k4"
branch: "[lane]/[slug]"
lane: "tiny | normal | high-risk"
outcome: "success | partial | blocked | abandoned"
duration_min: 0
commits: 0
files_changed: 0
---

# Trace: [Branch slug hoặc task name]

> File này lưu local trong `.work/traces/` (đã gitignore).
> Mục đích: ghi lại lần làm việc này cho bản thân + team retrospective.
> Tự fill phần lớn từ git, chỉ điền tay 3 phần: outcome, lessons, friction.

## 🎬 Bối cảnh

[1-2 câu: đang làm task gì, vì sao]

## 🛠️ Bạn (hoặc Claude) đã làm gì

[Auto từ commit messages — `git log main..HEAD --pretty=format:"%s"`]

1. 
2. 
3. 

## 📂 Files affected

[Auto từ `git diff --name-only main...HEAD` và `--stat`]

**Created:**
- 

**Modified:**
- 

**Deleted:**
- 

## 💬 PR liên quan

[Nếu đã mở PR: link + status]

- PR: #
- Status: open / merged / closed
- Reviewers: 

## ✅ Outcome

[Chọn 1: success / partial / blocked / abandoned]

[Mô tả ngắn — task này đi đến đâu?]

## 🧠 Bài học (optional, nhưng quý)

[Học được gì? Có thể bỏ qua nếu không có gì đáng chú ý.]

- 
- 

## 🚨 Friction phát hiện

[Có gì khó/cản trở quy trình không? Nếu có → mở GitHub issue label `friction`.]

- [ ] Friction 1: 
- [ ] Friction 2: 

**☐ Không có friction tuần này**

## 🔗 Liên quan

- Branch: 
- Commits: [list hashes hoặc range]
- PR: #
- Issues closed: 
- Decisions referenced: D-XXX

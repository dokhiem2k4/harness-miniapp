---
description: Phân loại task mới, tạo branch + skeleton file
allowed-tools: Read, Glob, Grep, Bash, Write
---

# /intake — Bắt đầu task mới (Git workflow)

Bạn là Claude, giúp member của team xử lý 1 task mới theo workflow Git.

## Task description từ user

$ARGUMENTS

## Quy trình

### Bước 1: Đọc context

Đọc:
1. `_context/project-overview.md`
2. `_context/team-members.md` (để biết user là ai từ git config)
3. `_context/conventions.md`
4. `_meta/intake-rules.md`
5. `CONTRIBUTING.md` (workflow Git)

### Bước 2: Hỏi 8 risk flags

Hỏi user từng câu (Y/N):

1. Sửa file ngoài thư mục cá nhân của bạn (vd: `shared/`, `_meta/`, `_context/`)?
2. Cần phối hợp với >1 người?
3. Có thông tin nhạy cảm (privacy/IP)?
4. Thay đổi cấu trúc folder/đặt tên/schema?
5. Khó hoàn tác trong 1 thao tác?
6. Liên quan dữ liệu/dịch vụ bên ngoài?
7. Đề xuất sửa convention/template/schema?
8. Phạm vi chưa rõ ràng?

### Bước 3: Phân loại lane

- **0 flag → 🟢 Tiny**: Branch `tiny/[slug]`, 1 PR đơn giản
- **1-3 flags → 🟡 Normal**: Branch `normal/[slug]`, full PR template
- **4+ flags → 🔴 High-Risk**: DỪNG, hỏi user đã tạo issue thảo luận chưa

### Bước 4: Tạo branch + skeleton

**Cho Tiny:**

```bash
git checkout main
git pull
git checkout -b tiny/[slug]
```

Sau đó hướng dẫn user sửa file trực tiếp.

**Cho Normal:**

```bash
git checkout main
git pull
git checkout -b normal/[slug]
```

Tạo file content trong `shared/content/[loại]/[slug]-[YYYY-MM-DD].md`:

```yaml
---
title: "[Title từ user input]"
author: "[git config user.name]"
type: "normal"
created: [YYYY-MM-DD]
status: "draft"
tags: []
---

# [Title]

## TL;DR

[Member fill]

## Mục đích

[Member fill]

## Phạm vi

### Trong scope
- 

### Ngoài scope
- 

## Nội dung chính

[Member fill]

## Nguồn tham khảo

- 
```

**Cho High-Risk:**

```
⚠️ HIGH-RISK TASK DETECTED

Trước khi code, bạn cần:

1. Tạo GitHub issue thảo luận direction:
   gh issue create --template proposal.yml

2. Đợi ít nhất 1 reviewer đồng ý direction

3. Khi có buy-in, quay lại /intake để tạo branch
```

Hỏi user: "Bạn đã có issue discussion chưa? (y/n)"

Nếu **n** → STOP, hướng dẫn tạo issue.

Nếu **y** → Hỏi issue number, tạo branch `high-risk/[slug]`, tạo story packet folder `.work/story-[id]/` với 4 file: overview.md, design.md, execplan.md, validation.md.

### Bước 5: Tổng kết

```
📋 TASK CLASSIFICATION
━━━━━━━━━━━━━━━━━━━━━
Task: [mô tả]
Lane: [emoji + tên lane]
Flags: [n]/8

🌳 Branch created:
   [branch name]

📁 Files created:
   [list path]

🎯 Next steps:
   1. [bước cụ thể]
   2. Commit thường xuyên: git commit -m "[lane]: ..."
   3. Khi xong: git push + /pr

💡 Tips:
   - Pull main hàng ngày để tránh conflict
   - Nếu gặp friction → mở issue với template friction.yml
```

## Quy tắc tuyệt đối

- ❌ KHÔNG commit thẳng vào `main` — luôn tạo branch
- ❌ KHÔNG tự chọn lane cao hơn để "cẩn thận" — dựa đúng flags
- ❌ KHÔNG tạo file trong `_meta/` hoặc `_context/` mà không qua flow high-risk
- ✅ Verify git config user.name match với `_context/team-members.md`
- ✅ Nếu user chưa pull main → pull trước khi tạo branch
- ✅ Slug rules: lowercase, dash-separated, max 50 chars, không có ngày tháng

# Intake Rules — Quy tắc phân loại task (GitHub edition)

> Mọi PR mới phải đi qua "intake gate" này.
> Mục tiêu: việc nhỏ merge nhanh, việc lớn được thảo luận kỹ.

## 3 lanes

### 🟢 Tiny — Branch `tiny/*`

**Đặc điểm:**
- Sửa typo, format, link hỏng
- Update small metadata (frontmatter field)
- Thêm 1-2 dòng vào file đã có
- Tổng diff: ~10 dòng

**Quy trình:**
- Branch: `tiny/[slug]`
- PR template: `tiny.md`
- Reviewers: 1 (CODEOWNERS auto-assign)
- Merge strategy: Squash
- CI: phải pass
- Trace log: **KHÔNG cần**

**Time to merge target:** Same day

---

### 🟡 Normal — Branch `normal/*`

**Đặc điểm:**
- Tạo file content mới (article, doc, spec)
- Sửa nội dung quan trọng trong file đã có
- Thêm section mới đáng kể
- Tổng diff: ~10-500 dòng

**Quy trình:**
- Branch: `normal/[slug]`
- PR template: `normal.md`
- Reviewers: 1+ (CODEOWNERS)
- Merge strategy: Squash
- CI: tất cả workflows phải pass
- Trace log: **BẮT BUỘC** (local `.work/traces/`)

**Time to merge target:** 1-3 days

---

### 🔴 High-Risk — Branch `high-risk/*`

**Đặc điểm (1 trong các flags sau là đủ):**
- 📁 **Shared impact**: Sửa nhiều file trong `shared/`
- 👥 **Multi-person**: Cần >1 người làm
- 🔒 **Sensitive**: Thông tin riêng tư, bản quyền
- 🏗️ **Structural**: Đổi cấu trúc folder/schema/naming
- ↩️ **Irreversible**: Khó hoàn tác
- 🌐 **External**: Liên quan dữ liệu/dịch vụ bên ngoài
- 📜 **Convention**: Sửa quy ước/template
- ❓ **Unknown scope**: Phạm vi chưa rõ

**Quy trình:**
- **BƯỚC 0 (BẮT BUỘC)**: Tạo issue thảo luận direction TRƯỚC khi code
  ```bash
  gh issue create --template proposal.yml
  ```
- Branch: `high-risk/[slug]`
- PR template: `high-risk.md`
- Reviewers: **2+** (CODEOWNERS rule cho high-risk)
- Merge strategy: Squash (preserve commit messages)
- CI: tất cả workflows phải pass
- **Decision Record D-NNN BẮT BUỘC** trong `shared/DECISIONS.md`
- (Nếu kiến trúc) **ADR** trong `shared/adr/ADR-NNN-*.md`
- Trace log: BẮT BUỘC + chi tiết

**Time to merge target:** 3-14 days

---

## 🎯 Decision Tree

```
Bắt đầu: User mô tả task
   │
   ├─ Có sửa file ngoài thư mục cá nhân không?
   │   │
   │   ├─ KHÔNG → 🟢 Tiny (tự do làm)
   │   │
   │   └─ CÓ → Đếm số risk flags
   │       │
   │       ├─ 0 flag: 🟢 Tiny
   │       ├─ 1-3 flags: 🟡 Normal
   │       └─ 4+ flags: 🔴 High-Risk
   │
   └─ Có dấu hiệu unsafe (xoá nhiều file, đảo ngược DR)?
       └─ STOP, hỏi user + tạo issue thảo luận
```

## Risk Flags Checklist

Tick các flag, đếm tổng:

| # | Flag | Tick nếu... |
|---|------|-------------|
| 1 | 📁 Shared impact | Thay đổi file trong `shared/` |
| 2 | 👥 Multi-person | Cần >1 người làm |
| 3 | 🔒 Sensitive | Có thông tin riêng tư, bản quyền, danh tính |
| 4 | 🏗️ Structural | Đổi cấu trúc folder, đặt tên, schema |
| 5 | ↩️ Irreversible | Khó hoàn tác trong 1 thao tác |
| 6 | 🌐 External | Liên quan dữ liệu/dịch vụ bên ngoài |
| 7 | 📜 Convention | Đề xuất sửa quy ước/template/schema |
| 8 | ❓ Unknown scope | Phạm vi chưa rõ ban đầu |

## Ví dụ phân loại

| Tình huống | Lane | Lý do |
|------------|------|-------|
| Sửa typo trong 1 article ở `shared/` | 🟢 Tiny | Shared impact NHƯNG diff cực nhỏ, dễ revert |
| Viết article mới về phở | 🟡 Normal | Tạo content mới trong `shared/`, có template |
| Đổi tên folder `shared/content/articles/` | 🔴 High-Risk | Structural + nhiều flag |
| Sửa CI workflow `.github/workflows/` | 🔴 High-Risk | Sensitive (CI affects everyone) |
| Đề xuất convention mới cho frontmatter | 🔴 High-Risk | Convention flag |
| Update `_context/team-members.md` khi có người mới | 🟡 Normal | Shared impact nhưng straightforward |
| Tạo template mới trong `_meta/templates/` | 🔴 High-Risk | Convention + structural |
| Sửa link broken trong README | 🟢 Tiny | Sửa nhỏ, easy revert |

## ⚠️ Edge cases

### "Lần đầu tôi làm task này, không biết lane nào"

→ Chọn lane CAO hơn. Thừa cẩn thận tốt hơn thiếu.

### "Tôi đã merge tiny PR nhưng phát hiện nó là high-risk thật"

→ Mở issue retrospective. Discuss với team. Có thể cần revert + redo qua high-risk flow.

### "Task của tôi không fit lane nào"

→ Hỏi team lead. Nếu thật sự không fit → có thể cần lane mới (đề xuất qua proposal issue).

### "CI fail nhưng tôi confident code đúng"

→ ĐỌC CI log. Nếu CI sai → mở bug issue. KHÔNG bypass CI.

## Khi nào revisit intake rules

Đề xuất sửa file này khi:
- ≥3 friction issues phàn nàn về lane classification
- Có lane mới cần thêm (vd: `experiment/`, `release/`)
- Risk flags không cover được case mới

Quy trình sửa: Tạo PR với label `area:meta` + `harness-improvement`.

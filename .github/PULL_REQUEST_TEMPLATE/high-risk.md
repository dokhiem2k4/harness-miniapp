## 🔴 High-Risk Change

> ⚠️ **Trước khi mở PR này, bạn đã:**
> - [ ] Tạo issue thảo luận direction TRƯỚC
> - [ ] Có ít nhất 1 reviewer/team lead đồng ý direction
> - [ ] Đọc lại `_meta/intake-rules.md` để xác nhận đây thật sự là high-risk
>
> Nếu chưa — đóng PR này, mở issue trước.

---

### 🎯 1. Vấn đề (Problem statement)

<!-- 3-5 câu về tình hình hiện tại, vấn đề, áp lực dẫn đến cần thay đổi này. -->


### 🚨 2. Tại sao là HIGH-RISK?

<!-- Tick ít nhất 1 trong các flags sau -->

- [ ] 📁 **Shared impact** — Thay đổi nhiều file trong `shared/`
- [ ] 👥 **Multi-person** — Cần >1 người làm
- [ ] 🔒 **Sensitive** — Thông tin riêng tư, bản quyền, danh tính
- [ ] 🏗️ **Structural** — Đổi cấu trúc folder, schema, naming
- [ ] ↩️ **Irreversible** — Khó hoàn tác
- [ ] 🌐 **External** — Liên quan dữ liệu/dịch vụ bên ngoài
- [ ] 📜 **Convention** — Đề xuất sửa quy ước/template
- [ ] ❓ **Unknown scope** — Phạm vi chưa rõ ban đầu


### 👥 3. Người liên quan

- **Story owner:** @<username>
- **Cộng tác:** @<username>, @<username>
- **Reviewers cần thiết:** @<username>, @<username>
- **Người bị ảnh hưởng:** <ai sẽ thấy thay đổi này?>


### 🎯 4. Tiêu chí "Done"

<!-- Khi nào coi là hoàn thành? -->

- [ ] Tiêu chí 1 (có thể verify được)
- [ ] Tiêu chí 2
- [ ] **Decision Record D-NNN added in `shared/DECISIONS.md`**
- [ ] (Nếu kiến trúc) **ADR added in `shared/adr/`**
- [ ] CHANGELOG entry added
- [ ] (Nếu cần) Migration guide for affected files


### 🛣️ 5. Phương án đề xuất

<!-- Tóm tắt phương án. Chi tiết kỹ thuật → file design.md trong story packet. -->


### ⚖️ 6. Alternatives đã xét

#### Option A: <name> ✅ CHỌN
- Mô tả:
- Ưu:
- Nhược:

#### Option B: <name> ❌ LOẠI
- Mô tả:
- Lý do loại:

#### Option C: Status quo (không làm gì) ❌ LOẠI
- Lý do tại sao không thể giữ nguyên:


### ⏱️ 7. Kế hoạch thực thi

| Phase | Việc | Người làm | Thời gian | Trạng thái |
|-------|------|-----------|-----------|------------|
| 1 |  |  |  | ⬜ |
| 2 |  |  |  | ⬜ |
| 3 | Review |  |  | ⬜ |


### ✅ 8. Kiểm chứng

<!-- Sau khi xong, làm sao biết PR này work? -->

- [ ] Test case 1:
- [ ] Test case 2:
- [ ] No regression in existing files (run `./scripts/pr-check.sh`)


### ⚠️ 9. Plan B nếu thất bại

<!-- Nếu phương án không work, làm gì? Có rollback được không? -->


### ❓ 10. Câu hỏi còn mở

- [ ] Câu hỏi 1 cần team lead trả lời:
- [ ] Câu hỏi 2 cần thảo luận:


### 🔗 11. Liên quan

- **Discussion issue:** #
- **Closes:** #
- **Related decisions:** D-XXX, ADR-YYY


### 📊 12. Impact estimate

- **Files affected:** ~N files
- **People affected:** N members
- **Estimated time saved/cost:** 
- **Risk if PR is wrong:** Low / Medium / High

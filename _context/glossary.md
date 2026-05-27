# Glossary — Từ điển thuật ngữ

> Claude tra ở đây khi gặp từ lạ thay vì đoán.

## Thuật ngữ harness

### Harness
Hệ điều hành cấp repo — gồm cấu trúc + quy ước + công cụ — giúp người và AI làm việc cùng nhau.

### Lane
Đường thực thi cho mỗi loại task: tiny / normal / high-risk.

### Branch lane
Tiền tố trong tên branch (`tiny/`, `normal/`, `high-risk/`).

### CODEOWNERS
File định nghĩa auto-assign reviewer cho từng path.

### CI (Continuous Integration)
GitHub Actions tự chạy validation cho mỗi PR.

### Decision Record (DR)
Quyết định bền vững, format `D-NNN` trong `shared/DECISIONS.md`.

### ADR (Architecture Decision Record)
DR cho quyết định kiến trúc, mỗi ADR 1 file trong `shared/adr/`.

### Friction
Khó khăn với quy trình harness — ghi qua GitHub Issue label `friction`.

### Retrospective
Tổng kết tuần/sprint — trong `shared/retrospectives/`.

### Story Packet
Folder local chứa overview + design + execplan + validation cho high-risk task.

## Thuật ngữ GitHub

### PR (Pull Request)
Yêu cầu merge branch vào main, có review process.

### Squash merge
Gộp tất cả commits của PR thành 1 commit khi merge.

### Branch protection
Rules trên main: require PR, require CI pass, require review.

## Thuật ngữ dự án (BẠN ĐIỀN)

### [Thuật ngữ 1]
[Định nghĩa]

### [Thuật ngữ 2]
[Định nghĩa]

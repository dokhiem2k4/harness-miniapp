# Validation Matrix — Cách verify output (GitHub edition)

> Validation chia 2 lớp: **CI tự động** + **Reviewer manual**.

## Lớp 1: CI tự động (mỗi PR)

| Workflow | Kiểm tra | Block merge? |
|----------|----------|--------------|
| `validate-frontmatter.yml` | YAML frontmatter có đủ field, format đúng | ✅ Yes |
| `validate-schemas.yml` | Frontmatter match schema YAML | ✅ Yes |
| `markdown-lint.yml` | Markdown format + file naming convention | ✅ Yes |
| `pr-labeler.yml` | Auto-apply labels theo branch + path | ❌ No (informational) |

CI fail → fix LOCAL, push lại, không bypass.

## Lớp 2: Reviewer manual

### Cho mọi PR (theo lane)

**Tiny (1 reviewer):**
- [ ] Diff hợp lý với mô tả PR
- [ ] Không có side effect bất ngờ

**Normal (1 reviewer):**
- [ ] PR body fill đủ template
- [ ] Self-check checklist đã tick
- [ ] Content quality (đọc thật, không chỉ glance)
- [ ] Consistency với content cũ
- [ ] Source citations (nếu có claim)

**High-risk (2 reviewers):**
- [ ] Tất cả của Normal +
- [ ] Decision Record D-NNN exists
- [ ] (Nếu kiến trúc) ADR added
- [ ] Migration path documented
- [ ] Rollback plan có
- [ ] Discussion issue đã có buy-in

## Validation theo loại output

| Loại output | CI check | Reviewer check |
|-------------|----------|----------------|
| **Bài viết** | Frontmatter, naming | Content quality, sources |
| **Spec/Design** | Frontmatter | Implementability |
| **Decision Record** | Schema D-NNN | Context đủ, alternatives đã xét |
| **ADR** | Schema ADR-NNN | Trade-offs, migration, validation metrics |
| **Template** | Markdown lint | Backward compat với content cũ |
| **Convention change** | - | 1-week pilot period |
| **CI workflow** | Self-validation | Test trên branch trước |

## Content checklist (cho bài viết)

CI có thể check:
- ✅ Frontmatter format
- ✅ File naming
- ✅ Heading hierarchy (no skip levels)
- ✅ Markdown syntax

Reviewer phải check:
- ⏺ TL;DR ở đầu, dễ nắm
- ⏺ Câu chủ đề rõ ràng từng đoạn
- ⏺ Không lặp ý quá nhiều
- ⏺ Nguồn được trích dẫn
- ⏺ Không lộ thông tin riêng tư
- ⏺ Không vi phạm bản quyền
- ⏺ Tone & voice khớp với các bài cũ
- ⏺ Thuật ngữ dùng đúng glossary
- ⏺ Không mâu thuẫn DECISIONS gần đây

## Decision Record validation

- [ ] ID format `D-NNN` (3 digits)
- [ ] Context đủ rõ (6 tháng sau hiểu lại được)
- [ ] ≥2 alternatives đã xét
- [ ] Lý do loại các alternatives rõ ràng
- [ ] Hệ quả (positive + negative)
- [ ] Khi nào revisit
- [ ] Không mâu thuẫn DR active khác

## ADR validation

ADR nghiêm khắc hơn DR:
- [ ] Tất cả checklist DR +
- [ ] Sơ đồ minh hoạ (mermaid hoặc ASCII)
- [ ] Migration path nếu thay đổi structure
- [ ] Rollback plan
- [ ] Validation metrics (làm sao đo decision này work)
- [ ] Re-evaluate timeline

## Cadence

| Cadence | Việc |
|---------|------|
| Per PR | CI checks + reviewer checklist |
| Daily | Team lead triage queue |
| Weekly | Retrospective |
| Sprint (2 weeks) | Friction review |
| Quarterly | Audit shared/, archive deprecated |
| Yearly | Re-validate top 10 content files |

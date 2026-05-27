# AGENTS.md — Shim cho AI Coding Agents

> File chuẩn cho Cursor, Codex, Aider, Claude Code, và các agent khác.

## Bạn (Agent) đang ở đâu?

Repo GitHub của team **[TÊN_TEAM]**. Workflow: Git + Pull Requests + GitHub Actions CI.

## Đọc trước mọi task

1. `CLAUDE.md` — Routing rules đầy đủ
2. `CONTRIBUTING.md` — Workflow Git
3. `_context/project-overview.md`
4. `_meta/intake-rules.md`

## Workflow chính

```bash
# Mọi task qua branch + PR
git checkout main && git pull
git checkout -b [lane]/[slug]
# ... làm việc ...
git commit -m "[lane]: description"
git push -u origin [lane]/[slug]
gh pr create
```

## Slash commands (Claude Code)

- `/intake [task]` — Phân loại + tạo branch
- `/pr` — Tạo Pull Request
- `/trace` — Trace log (local)
- `/review` — Team lead review
- `/retro` — Weekly retrospective
- `/status` — Dashboard

## Quy tắc tuyệt đối

1. KHÔNG commit thẳng vào `main`
2. KHÔNG bypass CI
3. KHÔNG force push branch đã có review
4. KHÔNG self-approve PR

## Compatibility

- Claude Code: full support qua `.claude/commands/`
- Cursor: đọc CLAUDE.md + AGENTS.md
- Codex CLI: đọc AGENTS.md
- Aider: tương thích Git workflow

# Project: OhMyClaude Books

Online bookstore built as two Laravel services running under Laravel Octane
in worker mode — no php-fpm, no FastCGI.

## Structure

- `services/catalog/` — book catalog (authors, series, genres, tags, search),
  runtime: FrankenPHP
- `services/orders/` — cart and checkout, runtime: RoadRunner
- `charts/ohmyclaude/` — Helm chart for Kubernetes
- `docs/plan.md` — the approved implementation plan and readiness criteria;
  the reference for what to build and when the work is done
- `docs/research/` — findings that informed the code, kept as our own notes
- `docs/adr/` — architecture decision records
- `docs/architecture.md` — Mermaid diagrams
- `docker-compose.yml` — local stack: both services, PostgreSQL, Redis
- `.github/workflows/` — CI

## Stack

Laravel 13 on PHP 8.4, Laravel Octane 2.x, PostgreSQL (one database per
service), Redis for cache and queues, Pest for tests.

## Conventions

- Work in small steps: plan, implement one stage, verify, commit.
- Before each commit: run `php artisan test` and the linter in the service
  you changed.
- Commit messages: English, imperative mood, one stage per commit.
- Area-specific conventions (Laravel, Octane worker mode, containers,
  database, Helm, GitHub Actions) live in `.claude/rules/` and load
  automatically for matching files — do not duplicate them here.

## Restrictions

- Never commit secrets: `.env`, `*.key`, tokens, passwords.
- Never run destructive commands against data volumes or remote environments.
- Do not push to remote unless explicitly asked.

## Reviewing changes

- Laravel code changed → run the `code-reviewer` subagent.
- Migrations or schema changed → run the `db-reviewer` subagent.
- Containers, chart or workflows changed → run the `security-auditor` subagent.
- `/project-review` — full checklist across all layers.

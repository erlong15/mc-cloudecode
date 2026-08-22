---
name: docker-stack
description: Procedure for building the local stack - images per project rules, compose with healthchecks, and diagnosing unhealthy containers. Use when creating or fixing Dockerfiles and docker-compose.
---

# Building and diagnosing the local stack

## Build

1. Images follow `.claude/rules/containers.md`: pinned tags
   (`dunglas/frankenphp:1.12.7-php8.4-trixie`; `php:8.4-cli` + RoadRunner
   binary via `COPY --from=ghcr.io/roadrunner-server/roadrunner:2025.1.15`),
   multi-stage, non-root user, port ≥1024, `pcntl` and `pdo_pgsql` installed,
   writable `storage/` and `bootstrap/cache`, no secrets in layers.
2. Compose services: catalog (8000), orders (8001), `postgres:17`, `redis:7`.
   Every service declares a healthcheck; the app services check `GET /health`,
   postgres — `pg_isready`, redis — `PING`.
3. App services depend on postgres/redis with `condition: service_healthy`.
   Migrations run on container start, before the Octane server.

## Diagnose (when containers are not healthy)

Work the sequence, do not guess:

1. `docker compose ps` — which service, which state (starting/unhealthy/exited).
2. `docker compose logs <service>` — the actual error is almost always here.
3. Typical causes, most frequent first: migrations failed or database not
   ready (check depends_on conditions); `/health` route missing or failing;
   port mismatch between healthcheck and the port Octane listens on;
   missing PHP extension (`pdo_pgsql`, `pcntl`); permissions on `storage/`
   for the non-root user; wrong environment variables for the database.
4. After a fix: `docker compose up -d --build <service>`, re-check `ps`.

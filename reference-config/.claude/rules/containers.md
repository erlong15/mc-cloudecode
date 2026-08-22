---
paths:
  - "**/Dockerfile"
  - "docker-compose.yml"
  - "**/docker-compose*.yml"
---

# Container rules

- Pin base images to an exact tag. The `latest` tag is forbidden.
  - FrankenPHP service: `dunglas/frankenphp:1.12.7-php8.4-trixie`
    (images are published under `dunglas/`, not `php/`).
  - RoadRunner service: `php:8.4-cli` plus the RoadRunner binary copied in with
    `COPY --from=ghcr.io/roadrunner-server/roadrunner:2025.1.15 /usr/bin/rr /usr/local/bin/rr`.
  - Infrastructure in docker-compose is pinned too: `postgres:17`, `redis:7`.
- Install extensions with `install-php-extensions`. Octane requires `pcntl`;
  PostgreSQL requires `pdo_pgsql`.
- Run as a non-root user. Listen on a port at or above 1024 so no
  capabilities are needed; set `SERVER_NAME` accordingly for FrankenPHP.
- Grant the runtime user write access to `storage/` and `bootstrap/cache`.
- Never copy `.env`, keys, or tokens into an image layer.
- Multi-stage builds: dependencies installed in a builder stage, only the
  application and vendor directory shipped in the final stage.
- Every service in `docker-compose.yml` declares a healthcheck.

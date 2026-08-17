---
name: project-review
description: Full review checklist for OhMyClaude Books - Laravel code, Octane worker mode, migrations, containers, Helm chart and GitHub Actions. Use when reviewing changes, a pull request, or the project as a whole.
---

# Project review checklist

Go through the sections relevant to the changed files. Mark every item
explicitly: pass / violation / not applicable.

## Laravel code

1. `declare(strict_types=1);` present; parameters and returns typed.
2. Validation in form requests; responses through API resources.
3. Controllers thin — business logic in actions or services.
4. New endpoints covered by Pest feature tests, success and failure paths.

## Octane worker mode

5. No container, `Request`, or config injected into singleton constructors.
6. No static properties accumulating state between requests.
7. No use of `Octane::concurrently()`, ticks, or the `octane` cache driver
   (Swoole-only; this project runs FrankenPHP and RoadRunner).
8. `--max-requests` configured for production workers.

## Database

9. Migrations reversible: both `up()` and `down()` implemented.
10. `UPDATE`/`DELETE` always with `WHERE`; bulk changes batched.
11. Indexes on existing tables created concurrently.
12. Foreign keys constrained and indexed; money as `NUMERIC(12,2)` with
    a non-negative check; timestamps as `timestamptz`.

## Containers

13. Base images pinned to exact tags; no `latest`.
14. `pcntl` and `pdo_pgsql` installed; non-root user configured.
15. No secrets copied into image layers; healthchecks defined in compose.

## Helm chart

16. `securityContext` complete: non-root, no privilege escalation,
    all capabilities dropped.
17. Resource requests and limits set; probes defined.
18. Images by tag or digest; secrets via `Secret` objects.
19. `helm lint` and `helm template` pass.

## GitHub Actions

20. `permissions` declared explicitly and minimally.
21. No `pull_request_target` with checkout of pull request code.
22. No event context interpolated directly into `run` blocks.
23. Actions pinned; secrets referenced only through `secrets.*`.

## Report format

- Table: item → status → file:line → recommendation.
- Conclusion: verdict on whether the change can be accepted, and an overall
  risk level (low / medium / high) with reasoning.

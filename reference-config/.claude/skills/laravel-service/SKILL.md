---
name: laravel-service
description: Procedure for creating a new Laravel service under Octane in this project - scaffold, runtime install, strict types, Pest, healthcheck. Use when adding a service under services/.
---

# Creating a Laravel service under Octane

1. Scaffold into `services/<name>/` (Laravel 13, PHP 8.4). Skip the default
   SQLite setup — PostgreSQL connection comes from environment variables.
2. Install the runtime: `composer require laravel/octane`, then
   `php artisan octane:install --server=frankenphp` (catalog)
   or `--server=roadrunner` (orders). RoadRunner additionally needs
   `spiral/roadrunner-cli` and `./vendor/bin/rr get-binary`.
3. Apply project conventions from the start: `declare(strict_types=1);`
   in every file, form requests for validation, API resources for output,
   thin controllers.
4. Testing: Pest with `tests/Feature` and `tests/Unit`; every endpoint gets
   a feature test for success and failure paths.
5. Add `GET /health`: returns 200 with JSON status and checks the database
   connection — docker-compose healthchecks depend on it.
6. Verify before finishing: `php artisan test` green,
   `./vendor/bin/pint --test` clean,
   `php artisan octane:start` boots locally.

Worker-mode constraints are in `.claude/rules/octane.md` and apply to every
line written here.

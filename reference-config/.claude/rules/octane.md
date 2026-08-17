---
paths:
  - "services/**/*.php"
  - "services/**/Dockerfile"
  - "services/**/config/octane.php"
---

# Laravel Octane worker mode

The application is booted once and stays in memory between requests.
Code that is correct under php-fpm can leak or serve stale data here.

## Mandatory

- Never inject the container, `Illuminate\Http\Request`, or the config
  repository into a singleton constructor — the instance becomes stale.
  Use `bind()` instead of `singleton()`, or resolve inside the method.
- Global helpers `app()`, `request()`, `config()` are always current and safe.
  Type-hinting `Request` in a controller method is safe.
- No static properties that accumulate data between requests — that is
  a memory leak. Octane resets framework state, not yours.
- Always configure `--max-requests` in production so workers recycle.
- Run `php artisan octane:reload` after deployment, otherwise workers keep
  serving the old code.

## Not available on this stack

`Octane::concurrently()`, ticks/intervals, and the `octane` cache driver work
only on Swoole and OpenSwoole. This project runs FrankenPHP (catalog) and
RoadRunner (orders) — do not use those features.

## Runtimes

- catalog: FrankenPHP — PHP embedded in a Caddy-based server, no IPC,
  built-in TLS and HTTP/2 and HTTP/3.
- orders: RoadRunner — Go server with a pool of isolated PHP worker processes.

---
paths:
  - ".github/workflows/**"
---

# GitHub Actions rules

- Declare `permissions` explicitly at workflow or job level, granting the
  minimum required. Never rely on the default token scope.
- Never use `pull_request_target` together with a checkout of pull request
  code: that combination exposes secrets to untrusted code.
- Never interpolate event context (`github.event.*`) directly into a `run`
  block — that is a script injection. Pass values through `env` instead.
- Pin third-party actions; official `actions/*` at minimum by major tag.
- Secrets are referenced through `secrets.*` only, never written literally.
- Pin runtime versions explicitly (`python-version`, `php-version`);
  do not use floating specifiers.
- Jobs that only read the repository declare `contents: read`.

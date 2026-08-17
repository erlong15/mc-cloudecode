---
paths:
  - "services/**/*.php"
---

# Laravel conventions

- Laravel 13 on PHP 8.4. Use `declare(strict_types=1);` in every PHP file.
- Validation belongs in form requests, not in controllers.
- API responses are serialized through API resources.
- Controllers stay thin: business logic lives in actions or services.
- Use constructor promotion and typed properties.
- Tests are written with Pest in `tests/Feature` and `tests/Unit`.
- Every new endpoint gets a feature test covering success and failure paths.
- Database access goes through Eloquent models; raw SQL only where justified
  by a comment explaining why.

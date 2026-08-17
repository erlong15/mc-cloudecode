---
paths:
  - "services/**/database/**"
  - "**/*.sql"
---

# Database and migration rules

- Every migration is reversible: implement both `up()` and `down()`.
- `UPDATE` and `DELETE` require a `WHERE` clause. Bulk data changes run in
  batches, never as one transaction over the whole table.
- Indexes on existing tables are created concurrently
  (`CREATE INDEX CONCURRENTLY`, outside a transaction).
- Every foreign key column has a foreign key constraint and an index.
- Money is `NUMERIC(12,2)` with a `CHECK (amount >= 0)` constraint.
- Timestamps are `timestamptz`, defaulting to `now()`.
- Passwords and tokens are stored hashed, never in plain text.
- Do not mix schema changes and bulk data changes in one migration.
- Seeders produce synthetic data only; never embed real third-party content.

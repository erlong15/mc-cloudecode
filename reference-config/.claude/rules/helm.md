---
paths:
  - "charts/**"
---

# Helm chart rules

- Every container defines a `securityContext`: `runAsNonRoot: true`,
  `allowPrivilegeEscalation: false`, `capabilities: { drop: ["ALL"] }`,
  and `readOnlyRootFilesystem: true` where the workload allows it.
- `resources.requests` and `resources.limits` are mandatory.
- Images are referenced by tag or digest; `latest` is forbidden.
- Secrets come from `Secret` objects via `envFrom` or `valueFrom` —
  never as plain values in `values.yaml`.
- Every workload defines liveness and readiness probes.
- Values are documented in `values.yaml` with comments.
- The chart must pass `helm lint` and render with `helm template`.

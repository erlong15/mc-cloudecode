---
name: helm-chart
description: Procedure for creating and validating the project Helm chart - structure, values, probes, securityContext, lint/template checks. Use when working under charts/.
---

# Building and validating the Helm chart

1. One chart `charts/ohmyclaude` with both services as separate deployments
   plus services, configmap, secret references, ingress; postgres and redis —
   external or subcharts per the plan, not hand-rolled StatefulSets.
2. Every value used by templates is declared and commented in `values.yaml`;
   images referenced by tag or digest, never `latest`.
3. Every container carries the mandatory block from `.claude/rules/helm.md`:
   `runAsNonRoot: true`, `allowPrivilegeEscalation: false`,
   `capabilities: { drop: ["ALL"] }`, `readOnlyRootFilesystem` where the
   workload allows, resources requests and limits.
4. Probes: liveness and readiness on `GET /health`, with sane initial delays
   (Octane workers boot the app once — startup is not instant).
5. Secrets flow through `Secret` objects via `envFrom`/`valueFrom`;
   plain values in `values.yaml` are forbidden.
6. Validate before finishing — both must pass clean:
   `helm lint charts/ohmyclaude` and
   `helm template charts/ohmyclaude` (render, then scan the output for
   `latest`, missing resources, missing securityContext).

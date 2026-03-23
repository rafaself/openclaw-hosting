# AGENTS.md

## Scope
Applies only to `stacks/gcp/prod/`.

## Purpose
Compose the GCP modules into a production-oriented single-host deployment.

## Rules
- Compose modules instead of duplicating resource logic.
- Keep variables explicit and conservative.
- Prefer secure defaults.
- Do not place runtime secrets or provider/model config in this stack.

## Done when
- the stack composes cleanly,
- defaults remain secure,
- outputs are operationally useful.

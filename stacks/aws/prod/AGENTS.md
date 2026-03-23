# AGENTS.md

## Scope
Applies only to `stacks/aws/prod/`.

## Purpose
Compose the AWS modules into a production-oriented single-host deployment.

## Rules
- Compose modules instead of duplicating resource logic.
- Preserve the same logical contract used by the GCP stack.
- Keep variables explicit.
- Avoid runtime-specific secrets and onboarding logic here.

## Done when
- the stack remains structurally aligned with the GCP stack,
- inputs and outputs stay predictable,
- defaults remain conservative.

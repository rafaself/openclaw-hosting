# AGENTS.md

## Scope
Applies only to `bootstrap/`.

## Purpose
Provide post-provision operational scripts for installing the runtime and enabling private access.

## Rules
- Use strict shell mode.
- Fail fast.
- Keep scripts idempotent where possible.
- Separate install, private-access enablement, and onboarding.
- Use environment variables for values likely to vary.

## Done when
- a human operator can follow the scripts in order,
- the flow remains explicit,
- runtime onboarding is still a separate step.

# AGENTS.md

## Scope
Applies only to `modules/startup_common/`.

## Purpose
Provide reusable host-baseline startup logic shared across clouds whenever practical.

## Rules
- Scripts must be idempotent.
- Scripts must be safe to re-run.
- Install only baseline host dependencies here.
- Do not run interactive runtime onboarding here.
- Do not store secrets here.

## Preferred contents
- package setup,
- swap enablement,
- Tailscale installation,
- directory and log preparation.

## Done when
- scripts are reusable,
- scripts stay cloud-agnostic where practical,
- scripts remain small and predictable.

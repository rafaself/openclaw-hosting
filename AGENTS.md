# AGENTS.md

## Scope
Applies to the entire repository unless a deeper `AGENTS.md` overrides it.

## Repository intent
This repository provisions and bootstraps a minimal, secure, multi-cloud host foundation for self-hosted agent runtimes.

## Architecture rules
- Keep a stable logical contract across cloud modules.
- Do not create a single universal module with provider conditionals.
- `stacks/` compose modules; they do not duplicate module internals.
- `bootstrap/` should remain cloud-agnostic whenever practical.
- Runtime provider/model configuration is intentionally outside the infrastructure layer.

## Security rules
- Do not store secrets in state, tfvars, outputs, instance metadata, or committed files.
- Keep runtime services private by default.
- Separate administrative access from runtime access.
- Prefer loopback-bound services plus private overlays.

## Change rules
- Prefer the smallest viable change.
- Preserve module input/output compatibility unless explicitly refactoring contracts.
- Update nearby docs when behavior changes.
- If the same mistake repeats, update the nearest relevant `AGENTS.md`.

## Validation
Before considering work done:
- format and validate IaC,
- check shell script syntax,
- review bootstrap idempotence,
- confirm docs still match the code.

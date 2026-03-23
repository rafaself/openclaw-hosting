# Bootstrap

## Goals

Bootstrap prepares the host after infrastructure provisioning without forcing final runtime choices too early.

## Phases

### 1. Baseline host preparation
Examples:
- package update,
- install `curl`, `git`, `jq`, `ca-certificates`,
- create swap,
- install Tailscale,
- prepare directories and logs.

### 2. Runtime preparation
Examples:
- install the runtime using the official installer,
- skip onboarding initially,
- verify the binary is present.

### 3. Runtime onboarding
Examples:
- select runtime provider,
- select model,
- install daemon/service if desired,
- finalize auth and runtime config.

## Notes

- The initial scripts use the OpenClaw installer as the reference runtime flow.
- Override environment variables in `bootstrap/` if you want to adapt the same repository to another runtime later.

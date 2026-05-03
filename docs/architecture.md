# Architecture

## Intent

This repository is a multi-cloud foundation for secure self-hosted agent runtimes.

It is intentionally split into three layers:

1. **Infrastructure**
   - cloud resources such as VM, disk, metadata, and access wiring.

2. **Bootstrap**
   - host preparation and runtime software steps performed after provisioning.

3. **Runtime onboarding**
   - provider/model selection and final runtime setup, performed later.

## Core design principles

- generic in contract, specific in implementation,
- composition over over-abstraction,
- secure by default,
- bootstrap should be reusable across clouds whenever practical,
- secrets stay out of IaC state.

## Multi-cloud approach

Use provider-specific modules with a shared logical contract.

Examples:
- `modules/gcp_vm`
- `modules/aws_vm`

Both modules should expose similar logical outputs such as:
- instance ID,
- private IP,
- public IP,
- admin entrypoint,
- instance name.

The optional infrastructure startup baseline lives under `modules/startup_common`.

## First baseline

The first deployment baseline is:
- small VM,
- Debian 12 on GCP,
- 20 GB standard disk,
- private-access-first networking,
- post-provision runtime installer flow,
- onboarding deferred until later.

`tofu apply` is reserved for infrastructure changes. Tailscale enablement and OpenClaw installation happen later through the bootstrap scripts.

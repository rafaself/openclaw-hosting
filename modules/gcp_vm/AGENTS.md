# AGENTS.md

## Scope
Applies only to `modules/gcp_vm/`.

## Purpose
Provision the GCP VM and directly related host-baseline infrastructure.

## Responsibilities
- Compute Engine instance,
- boot disk,
- metadata and startup script attachment,
- optional public IP,
- minimal admin-access firewall rules when needed.

## Constraints
- Keep the logical interface aligned with `modules/aws_vm/`.
- Do not embed runtime provider/model settings here.
- Do not place secrets in metadata, outputs, or state.
- Prefer explicit variables over hidden defaults.

## Done when
- the module provisions a usable VM,
- outputs follow the shared logical contract,
- no runtime onboarding logic is embedded.

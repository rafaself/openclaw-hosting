# AGENTS.md

## Scope
Applies only to `modules/aws_vm/`.

## Purpose
Provision the AWS VM and directly related host-baseline infrastructure.

## Responsibilities
- EC2 instance,
- root volume,
- user data attachment,
- optional public IP behavior,
- minimal host-level configuration expected by the stack.

## Constraints
- Keep the logical interface aligned with `modules/gcp_vm/`.
- Do not embed runtime provider/model settings here.
- Do not place secrets in user data, outputs, or state.
- Keep networking inputs explicit.

## Done when
- the module provisions a usable EC2 instance,
- outputs follow the shared logical contract,
- no runtime onboarding logic is embedded.

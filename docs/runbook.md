# Runbook

## Provision
1. Choose the target stack.
2. Configure remote state backend.
3. Copy `terraform.tfvars.example` to `terraform.tfvars`.
4. Run `tofu plan` and `tofu apply`.

## Verify
1. Connect using the chosen admin method.
2. Confirm the host came up correctly.
3. Review startup logs if needed.

## Prepare private access
1. Run the private-access bootstrap script.
2. Join the machine to your Tailscale network.
3. Verify desktop and mobile reachability.

## Install runtime
1. Run the runtime installer script.
2. Confirm the binary exists.
3. Defer provider/model setup until you are ready.

## Onboard
1. Run the onboarding script.
2. Configure provider/model later as needed.
3. Confirm the runtime daemon/service is working if enabled.

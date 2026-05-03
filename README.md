# agent-runtime-foundation

Multi-cloud infrastructure and bootstrap foundation for secure self-hosted agent runtimes, with reusable modules for provisioning, host hardening, and private access.

## Scope

This repository provides an initial foundation for running agent runtimes on small cloud VMs with:

- provider-specific VM modules for GCP and AWS,
- an optional infrastructure startup baseline,
- private-access-first networking,
- layered `AGENTS.md` guidance for Codex and similar agents,
- runtime installation separated from runtime provider/model decisions.

The first reference deployment targets:

- a small Linux VM,
- Debian 12 on GCP,
- private access through Tailscale,
- post-provision runtime installation,
- runtime onboarding deferred until later.

## Design summary

The repository is intentionally split into three concerns:

1. **Infrastructure**
   - creates cloud resources such as VM, disk, network attachments, and access wiring.

2. **Bootstrap**
   - prepares host software after provisioning, such as packages, swap, Tailscale, and runtime installation.

3. **Runtime onboarding**
   - remains separate and can be performed later once the runtime provider/model is decided.

`tofu apply` is intentionally limited to infrastructure. Tailscale enablement, OpenClaw installation, and runtime onboarding belong to the post-provision bootstrap flow, not the infrastructure apply.

## Repository layout

```text
agent-runtime-foundation/
├─ AGENTS.md
├─ README.md
├─ Makefile
├─ .gitignore
├─ .codex/
│  └─ config.toml
├─ docs/
├─ stacks/
│  ├─ gcp/prod/
│  └─ aws/prod/
├─ modules/
│  ├─ gcp_vm/
│  ├─ aws_vm/
│  └─ startup_common/
├─ bootstrap/
└─ .github/workflows/
```

## Quick start

### 1. Pick a stack
Start with `stacks/gcp/prod` for the first deployment baseline.

### 2. Configure remote state
Backends are intentionally partial. Supply backend parameters at init time.

Examples:

```bash
cd stacks/gcp/prod
tofu init   -backend-config="bucket=YOUR_STATE_BUCKET"   -backend-config="prefix=agent-runtime-foundation/gcp-prod"
```

```bash
cd stacks/aws/prod
tofu init   -backend-config="bucket=YOUR_STATE_BUCKET"   -backend-config="key=agent-runtime-foundation/aws-prod/tofu.tfstate"   -backend-config="region=YOUR_AWS_REGION"
```

### 3. Copy the example variables
```bash
cp terraform.tfvars.example terraform.tfvars
```

Set `ssh_source_cidrs` explicitly if you want public SSH access. The default example keeps SSH closed until you replace it with trusted admin CIDRs such as `["203.0.113.10/32"]`.

Set `deletion_protection = true` on stacks you do not want removed accidentally during routine operations.

Set `enable_startup_bootstrap = true` only if you want a minimal host-baseline startup script during provisioning. The default keeps infrastructure apply free of host software bootstrap.

Set `create_dedicated_network = true` if you want the stack to create its own network boundary. Leave it `false` to keep using an existing VPC/subnet configuration.
The dedicated-network path is intentionally minimal; keep the existing-network path when you need custom routing, NAT, or pre-existing security controls.

### 4. Plan and apply
```bash
tofu plan
tofu apply
```

### 5. Bootstrap the host
After provisioning, connect to the VM and use the scripts in `bootstrap/`:

```bash
./bootstrap/01-post-ssh.sh
./bootstrap/03-enable-private-access.sh
./bootstrap/02-install-runtime.sh
```

`03-enable-private-access.sh` installs and enables Tailscale if needed. `02-install-runtime.sh` installs the reference runtime after infrastructure provisioning; OpenClaw is not installed by `tofu apply`.

### 6. Onboard later
When the runtime provider/model is decided:

```bash
./bootstrap/04-onboard-runtime.sh
```

## Runtime note

This repository is generic by design. The bootstrap scripts currently use the OpenClaw installer flow only as a reference post-provision runtime path. Override the environment variables in `bootstrap/` if you want a different runtime implementation later.

## Validation

Local validation targets:

```bash
make fmt
make validate
make shellcheck-lite
```

## Security defaults

- no public exposure of runtime application ports by default,
- no `0.0.0.0/0` SSH access by default; public SSH requires explicit trusted CIDRs,
- each GCP VM gets a dedicated attached service account with no broad IAM roles granted by default,
- deletion protection is available on both cloud stacks and stays opt-in by default,
- infrastructure apply does not install Tailscale or OpenClaw unless startup bootstrap is explicitly enabled,
- runtime services should prefer loopback binding,
- admin access and application access should stay separate,
- secrets do not belong in state, outputs, or committed tfvars,
- private access overlays are preferred over public service exposure.

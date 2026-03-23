# agent-runtime-foundation

Multi-cloud infrastructure and bootstrap foundation for secure self-hosted agent runtimes, with reusable modules for provisioning, host hardening, and private access.

## Scope

This repository provides an initial foundation for running agent runtimes on small cloud VMs with:

- provider-specific VM modules for GCP and AWS,
- a shared host bootstrap baseline,
- private-access-first networking,
- layered `AGENTS.md` guidance for Codex and similar agents,
- runtime installation separated from runtime provider/model decisions.

The first reference deployment targets:

- a small Linux VM,
- Debian 12 on GCP,
- private access through Tailscale,
- official runtime installer flow,
- runtime onboarding deferred until later.

## Design summary

The repository is intentionally split into three concerns:

1. **Infrastructure**
   - creates cloud resources such as VM, disk, network attachments, and access wiring.

2. **Bootstrap**
   - prepares the host with packages, swap, Tailscale, and directories.

3. **Runtime onboarding**
   - remains separate and can be performed later once the runtime provider/model is decided.

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

### 4. Plan and apply
```bash
tofu plan
tofu apply
```

### 5. Bootstrap the host
After provisioning, connect to the VM and use the scripts in `bootstrap/`:

```bash
./bootstrap/01-post-ssh.sh
./bootstrap/02-install-runtime.sh
./bootstrap/03-enable-private-access.sh
```

### 6. Onboard later
When the runtime provider/model is decided:

```bash
./bootstrap/04-onboard-runtime.sh
```

## Runtime note

This repository is generic by design, but the default example scripts currently use the OpenClaw installer flow as the initial reference runtime. Override the environment variables in `bootstrap/` if you want a different runtime implementation later.

## Validation

Local validation targets:

```bash
make fmt
make validate
make shellcheck-lite
```

## Security defaults

- no public exposure of runtime application ports by default,
- runtime services should prefer loopback binding,
- admin access and application access should stay separate,
- secrets do not belong in state, outputs, or committed tfvars,
- private access overlays are preferred over public service exposure.

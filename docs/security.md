# Security

## Default posture

- do not expose runtime application ports publicly by default,
- keep runtime services on loopback whenever possible,
- keep admin access separate from application access,
- prefer private-access overlays over public ingress,
- do not store secrets in IaC state, outputs, metadata, or committed tfvars.

## Private access strategy

Tailscale is the default private access layer because it provides:

- private overlay access for desktop and mobile,
- consistent access patterns across clouds,
- a practical path for serving private HTTPS endpoints for local-only services.

## Administrative access

Examples:
- GCP: OS Login-based SSH administration,
- AWS: EC2 Instance Connect Endpoint or a similarly controlled access path.

## Secrets policy

Use a dedicated secret manager later if the project needs persisted sensitive values.
This initial repository intentionally avoids embedding secrets in infrastructure definitions.

# GCP Stack

This stack provisions the initial GCP host baseline for the runtime foundation.

It is intended for a small single-VM deployment, with infrastructure provisioning kept separate from runtime onboarding and provider/model configuration.

## Before you run this stack

Complete these prerequisites first:

### 1. Create or choose a Google Cloud project

You need an existing Google Cloud project. Projects are the base unit for enabling services, billing, IAM, and resource creation in GCP. ([Google Cloud Documentation][1])

### 2. Link billing to the project

The project must be linked to an active Cloud Billing account before you can use billable Google Cloud services. ([Google Cloud Documentation][2])

### 3. Install and initialize the Google Cloud CLI

Install the Google Cloud CLI and sign in with your user account.

Example:

```bash
gcloud init
```

### 4. Set up Application Default Credentials for local IaC runs

For local Terraform/OpenTofu usage on GCP, Application Default Credentials are the recommended authentication method. Use:

```bash
gcloud auth application-default login
```

Google Cloud and Terraform documentation both recommend ADC for local development instead of downloading service account keys. ([Google Cloud Documentation][3])

### 5. Enable the required APIs

At minimum, enable the APIs required by the resources in this stack before the first apply.

For the current baseline, this typically includes:

* Compute Engine API
* Cloud Resource Manager API
* IAM API
* Cloud Storage API

You can enable services from the console or with `gcloud services enable ...`. A Google Cloud project is the unit where APIs are enabled and resources are managed. ([Google Cloud Documentation][1])

### 6. Create the remote state bucket

If this stack uses the GCS backend, the bucket must already exist before backend initialization. HashiCorp also recommends enabling Object Versioning for Terraform state recovery. ([HashiCorp Developer][4])

### 7. Decide your SSH administration model

This stack assumes OS Login is the preferred admin access path. OS Login manages SSH access through IAM instead of per-instance SSH key handling. ([Google Cloud Documentation][5])

If you will use OS Login, make sure your user has the appropriate IAM role, such as:

* `roles/compute.osLogin`
* `roles/compute.osAdminLogin`

OS Login can also be combined with stronger controls such as 2-step verification depending on your environment. ([Google Cloud Documentation][5])

## Local configuration

Before running `init` or `apply`, review and set:

* `project_id`
* `region`
* `zone`
* `instance_name`
* `machine_type`
* `disk_size_gb`
* `public_ip_mode`
* `ssh_source_cidrs` if you want public SSH access

Create your local variables file from the example:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then edit `terraform.tfvars` with your values.

`ssh_source_cidrs` is intentionally empty by default. Add only trusted admin CIDRs, for example `203.0.113.10/32`, when you need SSH exposed on a public IP.

## Remote state

This stack expects a pre-created GCS bucket for remote state.

Typical backend configuration values:

* bucket name
* state prefix

Initialize after the bucket exists:

```bash
tofu init
```

or

```bash
terraform init
```

## Recommended pre-flight checks

Run these before the first apply:

```bash
gcloud auth list
gcloud auth application-default print-access-token >/dev/null
gcloud config list project
```

These checks help confirm that your CLI session and ADC are both in place before Terraform/OpenTofu tries to create resources. ADC is the recommended local auth path for Terraform on GCP. ([Google Cloud Documentation][3])

## First run

```bash
tofu fmt -recursive
tofu validate
tofu plan
tofu apply
```

After provisioning:

1. connect to the VM,
2. verify the startup script completed,
3. enable the private access layer,
4. install the runtime using the official installer flow,
5. defer provider/model onboarding until later.


[1]: https://docs.cloud.google.com/resource-manager/docs/creating-managing-projects?utm_source=chatgpt.com "Creating and managing projects | Resource Manager"
[2]: https://docs.cloud.google.com/billing/docs/how-to/modify-project?utm_source=chatgpt.com "Enable, disable, or change billing for a project"
[3]: https://docs.cloud.google.com/docs/terraform/authentication?utm_source=chatgpt.com "Authentication for Terraform"
[4]: https://developer.hashicorp.com/terraform/language/backend/gcs?utm_source=chatgpt.com "Backend Type: gcs | Terraform"
[5]: https://docs.cloud.google.com/compute/docs/oslogin/set-up-oslogin?utm_source=chatgpt.com "Set up OS Login | Compute Engine"

# AWS Stack

This stack provisions the initial AWS host baseline for the runtime foundation.

It is intended for a small single-VM deployment, with infrastructure provisioning kept separate from runtime onboarding and provider/model configuration.

## Before you run this stack

Complete these prerequisites first:

### 1. Choose the target AWS account and region

Before the first apply, decide which AWS account and region this stack will use. Keep that choice consistent across your CLI profile, backend, and variables.

### 2. Install the AWS CLI

Install the AWS CLI locally and confirm it is available.

Example:

```bash
aws --version
```

The AWS CLI is the standard local interface for configuring credentials and region settings. ([AWS Documentation][6])

### 3. Configure authentication

The preferred local setup is AWS IAM Identity Center (SSO), using short-lived credentials from the AWS CLI.

Configure a profile:

```bash
aws configure sso
```

Then log in:

```bash
aws sso login --profile your-profile
```

AWS documents IAM Identity Center authentication in the CLI and recommends the SSO token provider configuration path. Terraform’s AWS provider also supports the same credential sources as the AWS CLI. ([AWS Documentation][7])

### 4. Decide your admin access model

This repository’s preferred AWS administration path is EC2 Instance Connect Endpoint, or another controlled private management path, instead of exposing SSH broadly.

EC2 Instance Connect Endpoint allows you to connect to instances without requiring the instance to have a public IPv4 address. ([AWS Documentation][8])

### 5. Create the remote state bucket

If this stack uses the S3 backend, create the bucket before backend initialization.

Terraform’s S3 backend supports state locking with `use_lockfile = true`. ([HashiCorp Developer][9])

### 6. Confirm required IAM permissions

Your AWS identity must be allowed to:

* use the selected region,
* read and write the remote state bucket,
* create and manage the resources defined by this stack,
* use the selected access model for instance administration.

## Local configuration

Before running `init` or `apply`, review and set:

* `instance_name`
* `instance_type`
* `ami_id`
* `create_dedicated_network` if you want the stack to create its own VPC and subnet
* `subnet_id` when reusing an existing subnet
* `vpc_security_group_ids` when reusing an existing subnet or custom security groups
* `disk_size_gb`
* `public_ip_mode`
* `deletion_protection`
* `enable_startup_bootstrap` if you want the minimal startup baseline during provisioning
* `key_name` if you use an EC2 key pair for administration

The dedicated-network path is a small single-subnet baseline. Reuse existing networking when you need custom routing, NAT, or established security group design.

Create your local variables file from the example:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then edit `terraform.tfvars` with your values.

If you are using a named AWS CLI profile, export it before running Terraform/OpenTofu:

```bash
export AWS_PROFILE=your-profile
export AWS_REGION=your-region
```

Terraform’s AWS provider supports the same authentication sources as the AWS CLI, including shared config and profile-based auth. ([HashiCorp Developer][10])

## Remote state

This stack expects a pre-created S3 bucket for remote state.

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
aws sts get-caller-identity --profile your-profile
aws s3 ls --profile your-profile
```

These checks confirm that the selected profile is authenticated and can reach AWS successfully.

## First run

```bash
tofu fmt -recursive
tofu validate
tofu plan
tofu apply
```

After provisioning:

1. verify the instance and network path,
2. confirm the admin access method works,
3. verify the startup baseline only if you explicitly enabled it,
4. enable the private access layer,
5. install the runtime using the post-provision installer flow,
6. defer provider/model onboarding until later.


[6]: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html?utm_source=chatgpt.com "Setting up the AWS CLI - AWS Command Line Interface"
[7]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html?utm_source=chatgpt.com "Configuring IAM Identity Center authentication with ..."
[8]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connect-with-ec2-instance-connect-endpoint.html?utm_source=chatgpt.com "Connect to your instances using a private IP address and ..."
[9]: https://developer.hashicorp.com/terraform/language/backend/s3?utm_source=chatgpt.com "Backend Type: s3 | Terraform"
[10]: https://developer.hashicorp.com/terraform/tutorials/configuration-language/configure-providers?utm_source=chatgpt.com "Configure Terraform providers"

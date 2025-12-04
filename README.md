# Terraform Google Workload Identity Federation Module

A Terraform module to set up Workload Identity Federation (WIF) for GitHub Actions on Google Cloud Platform. This allows GitHub Actions workflows to authenticate to GCP without using long-lived service account keys.

## Features

- Creates a Workload Identity Pool and OIDC provider for GitHub Actions
- Configures a service account with specified IAM roles
- Supports both repository-level and organization-level access patterns
- Automatically generates resource names with environment-based suffixes

## Usage

### Repository-Level Access

Grant access to a specific GitHub repository:

```hcl
module "wif" {
  source      = "github.com/your-org/terraform-google-wif"
  project_id  = "my-gcp-project"
  environment = "prod"
  github_repo = "my-org/my-repository"
  
  service_account_iam_member_roles = [
    "roles/iam.workloadIdentityUser"
  ]
}
```

### Organization-Level Access

Grant access to all repositories in a GitHub organization:

```hcl
module "wif" {
  source      = "github.com/your-org/terraform-google-wif"
  project_id  = "my-gcp-project"
  environment = "prod"
  name        = "my-app"
  github_org  = "my-github-org"
  
  service_account_iam_member_roles = [
    "roles/iam.workloadIdentityUser"
  ]
}
```

### Custom IAM Roles

Override default roles to match your deployment needs:

```hcl
module "wif" {
  source      = "github.com/your-org/terraform-google-wif"
  project_id  = "my-gcp-project"
  environment = "staging"
  github_repo = "my-org/my-repository"
  
  wif_iam_roles = [
    "roles/storage.admin",
    "roles/compute.instanceAdmin.v1"
  ]
  
  service_account_iam_member_roles = [
    "roles/iam.workloadIdentityUser"
  ]
}
```

## Using in GitHub Actions

After deploying this module, configure your GitHub Actions workflow:

```yaml
- name: Authenticate to Google Cloud
  uses: google-github-actions/auth@v2
  with:
    workload_identity_provider: ${{ secrets.WIF_PROVIDER }}
    service_account: ${{ secrets.WIF_SERVICE_ACCOUNT }}
```

Set these secrets in your repository:
- `WIF_PROVIDER`: Output from `wif_provider_name`
- `WIF_SERVICE_ACCOUNT`: Output from `service_account_email`

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| google | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The GCP project ID where resources will be created | `string` | n/a | yes |
| environment | Environment name (e.g., dev, staging, prod) | `string` | n/a | yes |
| service_account_iam_member_roles | IAM roles to grant on the service account | `list(string)` | n/a | yes |
| github_repo | GitHub repository in format 'org/repo' | `string` | `""` | no |
| github_org | GitHub organization name (takes precedence) | `string` | `""` | no |
| name | Name prefix when using github_org | `string` | `""` | no |
| wif_iam_roles | Project-level IAM roles for the service account | `list(string)` | `[see variables.tf]` | no |
| wif_attribute_mapping | OIDC claim to GCP attribute mappings | `map(string)` | `[see variables.tf]` | no |
| oidc_issuer_uri | OIDC issuer URI | `string` | `"https://token.actions.githubusercontent.com"` | no |

## Outputs

| Name | Description |
|------|-------------|
| wif_pool_ids | The fully-qualified Workload Identity Pool ID |
| wif_provider_name | The Workload Identity Provider resource name (use this for GitHub Actions) |
| service_account_email | The service account email for GitHub Actions |

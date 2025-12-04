variable "environment" {
  description = "Environment name (e.g., dev, staging, prod). Used as a suffix in resource naming."
  type        = string
}

variable "project_id" {
  description = "The GCP project ID where Workload Identity Federation resources will be created."
  type        = string
}

variable "name" {
  description = "Name prefix for resources when using organization-level WIF. Required if github_org is set, ignored if github_repo is used."
  type        = string
  default     = ""
}

variable "github_org" {
  description = "GitHub organization name to grant access to all repositories within the org. Takes precedence over github_repo if both are set."
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "GitHub repository in the format 'organization/repository'. Used to restrict WIF access to a specific repository. Ignored if github_org is set."
  type        = string
  default     = ""
}

variable "wif_attribute_mapping" {
  description = "Attribute mappings for Workload Identity Federation. Maps GitHub OIDC token claims to Google Cloud IAM attributes for fine-grained access control."
  type        = map(string)
  default = {
    "google.subject"       = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "attribute.workflow"   = "assertion.workflow"
    "attribute.ref"        = "assertion.ref"
    "attribute.actor"      = "assertion.actor"
  }
}

variable "wif_iam_roles" {
  description = "List of IAM roles to grant to the GitHub Actions service account at the project level. These define what GCP resources the GitHub workflows can access."
  type        = list(string)
  default = [
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    "roles/cloudbuild.builds.editor",
    "roles/artifactregistry.writer"
  ]
}

variable "service_account_iam_member_roles" {
  description = "List of IAM roles to grant on the service account itself. Typically includes 'roles/iam.workloadIdentityUser' to allow external identities to impersonate the service account."
  type        = list(string)
}

variable "oidc_issuer_uri" {
  description = "The OIDC issuer URI of the identity provider. For GitHub Actions, this is 'https://token.actions.githubusercontent.com'."
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

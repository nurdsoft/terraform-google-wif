variable "environment" {
  description = "List of environments to create"
  type        = string
}

variable "project_id" {
  description = "Project ID"
  type        = string
}

# Workload Identity Federation (WIF) related varaible
variable "github_repo" {
  description = "The repository name in the format organization/repository Used in WIF to restrict access to a specific GitHub repo"
}

# WIF attributes for GitHub OIDC
variable "wif_attribute_mapping" {
  type        = map(string)
  description = "map of attribute mappings used in Workload Identity Federation to translate GitHub OIDC token claims to Google Cloud IAM attributes."
  default = {
    "google.subject"       = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "attribute.workflow"   = "assertion.workflow"
    "attribute.ref"        = "assertion.ref"
    "attribute.actor"      = "assertion.actor"
  }
}

# List of specific GCP services assign to the GitHub deployer service account.
variable "wif_iam_roles" {
  type        = list(string)
  description = "List of IAM roles to assign to the GitHub deployer."
  default = [
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    "roles/cloudbuild.builds.editor",
    "roles/artifactregistry.writer"
  ]
}

# List of IAM roles to assign to the service account
variable "service_account_iam_member_roles" {
  type        = list(string)
  description = "List of IAM roles to assign to the service account."
}

# The OIDC issuer URI of the external identity provider
variable "oidc_issuer_uri" {
  type        = string
  description = "The OIDC issuer URI of the external identity provider"
  default     = "https://token.actions.githubusercontent.com"
}

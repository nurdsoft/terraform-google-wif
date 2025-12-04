locals {
  # Extract the GitHub repository name (e.g., "org/repo" → "repo")
  repo_name = split("/", var.github_repo)[1]
  # Common name prefix used for resource naming across the module
  name_prefix = "${local.repo_name}-${var.environment}"
  #   google_iam_workload_identity_pool attributes
  workload_identity_pool_id = "${local.name_prefix}-pool"
  pool_display_name         = "${local.repo_name} Actions Pool"
  pool_description          = "${local.repo_name} OIDC pool for GitHub Actions"
  #   google_iam_workload_identity_pool_provider attributes
  workload_identity_pool_provider_id = "${local.name_prefix}-provider"
  pool_provider_display_name         = "${local.name_prefix}-OIDC"
  #  google_service_account attributes
  gsa_account_id   = "${local.name_prefix}-gd-wif"
  gsa_display_name = "${local.repo_name} GitHub Actions Deployer"
}
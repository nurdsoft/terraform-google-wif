locals {
  # Extract the GitHub repository name (e.g., "org/repo" → "repo")
  repo_name = split("/", var.github_repo)[1]
  # Common name prefix used for resource naming across the module
  # truncated local.repo_name to fit the 32-char limit for Resource ID
  # For example: if repo_name = "very-long-repository-name" Then name_prefix becomes "very-long-repositor-dev" (18 chars from repo_name)
  name_prefix = "${substr(local.repo_name, 0, 18)}-${var.environment}"
  #   google_iam_workload_identity_pool attributes
  workload_identity_pool_id = "${local.name_prefix}-pool-${random_id.suffix.hex}"
  pool_display_name         = "${substr(local.repo_name, 0, 18)} Actions Pool"
  pool_description          = "${local.repo_name} OIDC pool for GitHub Actions"
  #   google_iam_workload_identity_pool_provider attributes
  workload_identity_pool_provider_id = "${local.name_prefix}-provider"
  pool_provider_display_name         = "${local.name_prefix}-OIDC"
  #  google_service_account attributes
  gsa_account_id   = "${local.name_prefix}-gd-wif-${random_id.suffix.hex}"
  gsa_display_name = "${local.repo_name} GitHub Actions Deployer"
}
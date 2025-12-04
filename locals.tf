locals {
  # Extract the GitHub repository name (e.g., "org/repo" → "repo")
  repo_name = var.github_repo != "" ? split("/", var.github_repo)[1] : ""
  
  # Common name prefix used for resource naming across the module
  # - Repo mode → use repo + env
  # - Org mode  → use name + env
  # - Truncated local.repo_name to fit the 32-char limit for Resource ID
  # For example: if repo_name = "very-long-repository-name" Then name_prefix becomes "very-long-repositor-dev" (18 chars from repo_name) and replace double hyphens (--) with a single hyphen (-)
  name_prefix = (
    var.github_org != "" ?
    replace("${substr(var.name, 0, 18)}-${var.environment}", "--", "-") :
    replace("${substr(local.repo_name, 0, 18)}-${var.environment}", "--", "-") 
  )
  
  # google_iam_workload_identity_pool attributes
  workload_identity_pool_id = "${local.name_prefix}-pool-${random_id.suffix.hex}"
  pool_display_name         = "${substr(local.name_prefix, 0, 18)} AP"
  pool_description          = (
    var.github_org != "" ?
    "${var.name} OIDC pool for GitHub Actions" :
    "${local.repo_name} OIDC pool for GitHub Actions" 
  )

  # google_iam_workload_identity_pool_provider attributes
  workload_identity_pool_provider_id = "${local.name_prefix}-provider"
  pool_provider_display_name         = "${local.name_prefix}-OIDC"

  # google_service_account attributes
  gsa_account_id   = "${local.name_prefix}-gd-${random_id.suffix.hex}"
  gsa_display_name = (
     var.github_org != "" ?
    "${var.name} Org-level GitHub Actions Deployer" :
    "${local.repo_name} GitHub Actions Deployer"  
  )

  # WIF restriction logic (attribute_condition used in provider)
  wif_attribute_condition = (
    var.github_org != "" ? "attribute.owner == \"${var.github_org}\"" : "attribute.repository == \"${var.github_repo}\""
  )

  # WIF member binding that defines which external identities (GitHub) 
  # can impersonate the service account. Behavior:
  # - If github_org is set: allow all repos in that org.
  # - Else if github_repo is set: allow only that repo.
  principal_set_prefix = "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${local.workload_identity_pool_id}"
  wif_member = (
    var.github_org != "" ?
    "${local.principal_set_prefix}/attribute.owner/${var.github_org}" :
    "${local.principal_set_prefix}/attribute.repository/${var.github_repo}"
  )
}

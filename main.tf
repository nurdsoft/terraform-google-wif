# Workload Identity Federation (WIF) related resources

# Fetch Project related details
data "google_project" "project" {
  project_id = var.project_id
}

# Creates a WIF pool to allow trusted external identities (like GitHub) to access GCP services
resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = local.workload_identity_pool_id
  display_name              = local.pool_display_name
  description               = local.pool_description
  project                   = var.project_id
}

# Defines the GitHub OIDC provider and maps OIDC claims to GCP attributes
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  depends_on                         = [google_iam_workload_identity_pool.github_pool]
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = local.workload_identity_pool_provider_id
  display_name                       = local.pool_provider_display_name
  oidc {
    issuer_uri = var.oidc_issuer_uri
  }
  attribute_mapping = var.wif_attribute_mapping
  # Restrict to a specific GitHub repository
  attribute_condition = "attribute.repository == \"${var.github_repo}\""
}

# A GCP service account that GitHub Actions will impersonate using OIDC.
resource "google_service_account" "github-deployer" {
  account_id   = local.gsa_account_id
  display_name = local.gsa_display_name
  project      = var.project_id
}

# Gives the SA permissions to deploy or access specific GCP services.
resource "google_project_iam_member" "required_apis" {
  for_each = toset(var.wif_iam_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.github-deployer.email}"
}

# Grants GitHub repo permission to impersonate the GCP service account via WIF
resource "google_service_account_iam_member" "github_oidc_binding" {
  for_each           = toset(var.service_account_iam_member_roles)
  service_account_id = google_service_account.github-deployer.name
  role               = each.value
  member             = "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_pool.workload_identity_pool_id}/attribute.repository/${var.github_repo}"
}
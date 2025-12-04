# Workload Identity Pool ID
output "wif_pool_ids" {
  description = "The fully-qualified ID of the Workload Identity Pool (format: projects/{project}/locations/global/workloadIdentityPools/{pool_id})."
  value       = google_iam_workload_identity_pool.github_pool.id
}

# Workload Identity Provider name
output "wif_provider_name" {
  description = "The resource name of the Workload Identity Provider. Use this value for the workload_identity_provider in GitHub Actions."
  value       = google_iam_workload_identity_pool_provider.github_provider.name
}

# Service Account email
output "service_account_email" {
  description = "The email address of the service account that GitHub Actions will impersonate via Workload Identity Federation."
  value       = google_service_account.github-deployer.email
}

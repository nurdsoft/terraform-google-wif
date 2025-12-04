# Workload Identity Pool ID
output "wif_pool_ids" {
  description = "Workload Identity Pool ID"
  value       = google_iam_workload_identity_pool.github_pool.id
}

# Service Account email
output "service_account_email" {
  description = "Service Account email"
  value       = google_service_account.github-deployer.id
}

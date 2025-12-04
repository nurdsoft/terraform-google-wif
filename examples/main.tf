module "wif-setup" {
  source      = "../"
  project_id  = "my-gcp-project"
  environment = "dev"
  github_repo = "my-org/my-repository"
  wif_attribute_mapping = {
    "google.subject"       = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "attribute.workflow"   = "assertion.workflow"
    "attribute.ref"        = "assertion.ref"
    "attribute.actor"      = "assertion.actor"
  }
  wif_iam_roles = [
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    "roles/cloudbuild.builds.editor",
    "roles/artifactregistry.writer"
  ]
  service_account_iam_member_roles = [
    "roles/iam.workloadIdentityUser"
  ]
}

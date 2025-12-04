module "wif-setup" {
  source      = "../../../modules/terraform-gcp-modules-wif"
  project_id  = "project_id"
  environment = "dev"
  github_repo = "nurdsoft/terraform-gcp-modules-wif"
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
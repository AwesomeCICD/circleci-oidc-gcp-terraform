resource "google_service_account" "sa" {
  account_id                   = var.gcp_service_account
  display_name                 = "A service account that only Vijay can use created via Terraform"
  project                      = var.gcp_project_id
  create_ignore_already_exists = true
}

resource "google_project_iam_member" "sa" {
  project = var.gcp_project_id
  role    = "roles/owner"
  member  = "serviceAccount:${var.gcp_service_account}@${var.gcp_project_number}.iam.gserviceaccount.com"
}

resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/projects/${var.gcp_project_number}/locations/global/workloadIdentityPools/${var.workload_identity_pool_id}/attribute.org_id/${var.circleci_oidc_org_id}",
  ]
}
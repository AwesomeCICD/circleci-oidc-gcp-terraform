data "google_service_account" "terraform_sa_account" {
  account_id = var.gcp_service_account # Replace with your service account ID
}

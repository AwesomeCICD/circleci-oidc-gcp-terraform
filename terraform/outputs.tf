

# Output all service account attributes
output "service_account_attributes" {
  value = {
    email        = data.google_service_account.terraform_sa_account.email
    unique_id    = data.google_service_account.terraform_sa_account.unique_id
    name         = data.google_service_account.terraform_sa_account.name
    display_name = data.google_service_account.terraform_sa_account.display_name
    member       = data.google_service_account.terraform_sa_account.member
  }
}
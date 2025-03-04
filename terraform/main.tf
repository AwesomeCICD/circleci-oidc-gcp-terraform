terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }

  backend "gcs" {
    bucket = "vijay-tf-state-gcp"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "676320558565"
  region  = "northamerica-northeast2"
  zone    = "northamerica-northeast2-a"
}


data "google_storage_bucket" "tf_state_bucket" {
  name = "vijay-tf-state-gcp"
}

output "bucket_name" {
  value = data.google_storage_bucket.tf_state_bucket.name
}
data "google_service_account" "terraform_sa_account" {
  account_id = "vijay-tf-gcp-service-account" # Replace with your service account ID
}


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

variable "circleci_server_domain" {
  type    = string
  #default = "server4.fieldeng-spehereci.com"
  default = "server-rc.gke.sphereci.com"
}

variable "circleci_oidc_org_id" {
  type    = string
  # server4 fieldeng
  #default = "552e8129-37b3-4335-997a-eda94ac5b342"
  # server rc
  default = "62ab4513-c6aa-4646-8189-a498fdbdb0d1"
}

variable "project_id" {
  type    = number
  default = 676320558565
}

variable "workload_pool_provider_id" {
    type = string
    default = "vijay-server47-pool-provider-id"
}

variable "circleci_project_id" {
    type = string
    # server4 fieldeng
    #default = "16b4151c-5f24-4ffe-ba21-70e96c1b9722"
    # server rc project id
    default = "4aef4297-932f-4e0f-b308-a3fad2844d7f"
  
}

variable "workload_identity_pool_id" {
    type = string
    default = "vijay-server47-pool"
}


import {
  id = "projects/${var.project_id}/locations/global/workloadIdentityPools/${var.workload_identity_pool_id}"
  to = google_iam_workload_identity_pool.cci_server_472_wip_pool
}


resource "google_iam_workload_identity_pool" "cci_server_472_wip_pool" {
  workload_identity_pool_id = "vijay-server47-pool"
  display_name              = "vijay-server47-identity-pool"
  description               = "Identity pool for OIDC setup in CCI Server 4.7.2"
  disabled                  = false
}


#resource "google_iam_workload_identity_pool" "pool" {
#  workload_identity_pool_id = "example-pool"
#}

#data "google_iam_workload_identity_pool" "cci_server_472_wip_pool" {
#  workload_identity_pool_id = "vijay-server47-pool"
#}

import {
  id = "projects/${var.project_id}/locations/global/workloadIdentityPools/${var.workload_identity_pool_id}/providers/${var.workload_pool_provider_id}"
  to = google_iam_workload_identity_pool_provider.pool
}

resource "google_iam_workload_identity_pool_provider" "pool" {
  workload_identity_pool_id          = "vijay-server47-pool"
  workload_identity_pool_provider_id = "vijay-server47-pool-provider-id"
  display_name                       = "vijay-server47-pool-provider-id"
  description                        = "Identity pool provider for OIDC setup in CCI Server 4.7.2"
  disabled                           = false
  attribute_mapping = {
    "attribute.project" = "assertion['${var.circleci_server_domain}/']"
    "attribute.org_id"  = "assertion.aud"
    "google.subject"    = "assertion.sub"
  }
  oidc {
    allowed_audiences = [var.circleci_oidc_org_id]
    issuer_uri = "https://${var.circleci_server_domain}/org/${var.circleci_oidc_org_id}"
  }
  depends_on = [ google_iam_workload_identity_pool.cci_server_472_wip_pool ]
}

resource "google_service_account" "sa" {
  account_id   = "vijay-tf-gcp-service-account"
  display_name = "A service account that only Vijay can use created via Terraform"
  project      = "dev-vijay-pandian"
  create_ignore_already_exists = true
}

resource "google_project_iam_member" "sa" {
  project = "dev-vijay-pandian"
  role    = "roles/owner"
  member  = "serviceAccount:vijay-tf-gcp-service-account@676320558565.iam.gserviceaccount.com"
}


resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/projects/676320558565/locations/global/workloadIdentityPools/${var.workload_identity_pool_id}/attribute.org_id/${var.circleci_oidc_org_id}",
  ]
}


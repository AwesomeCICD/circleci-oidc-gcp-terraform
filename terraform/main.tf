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

variable "project_id" {
  type = number
  description = "GCP project ID"
}


provider "google" {
  project = var.project_id
  region  = "northamerica-northeast2"
  zone    = "northamerica-northeast2-a"
}


data "google_storage_bucket" "tf_state_bucket" {
  name = "vijay-tf-state-gcp"
}

output "bucket_name" {
  value = data.google_storage_bucket.tf_state_bucket.name
}


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
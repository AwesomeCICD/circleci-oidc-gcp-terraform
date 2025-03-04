
data "google_storage_bucket" "tf_state_bucket" {
  name = var.circle_gcp_tf_state_bucket_name
}

output "bucket_name" {
  value = data.google_storage_bucket.tf_state_bucket.name
}
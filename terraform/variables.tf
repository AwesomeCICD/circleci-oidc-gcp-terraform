
variable "gcp_project_number" {
  type    = number
  default = 676320558565
}

variable "circleci_server_domain" {
  type    = string
  default = "server-rc.gke.sphereci.com"
}

variable "circleci_oidc_org_id" {
  type    = string
  default = "62ab4513-c6aa-4646-8189-a498fdbdb0d1"
}


variable "workload_identity_pool_id" {
  type    = string
  default = "vijay-server47-pool"
}


variable "workload_pool_provider_id" {
  type    = string
  default = "vijay-server47-pool-provider-id"
}

variable "circleci_project_id" {
  type    = string
  default = "4aef4297-932f-4e0f-b308-a3fad2844d7f"

}

variable "gcp_project_id" {
  type    = string
  default = "dev-vijay-pandian"
}

variable "gcp_service_account" {
  type    = string
  default = "vijay-tf-gcp-service-account"
}

variable "gcp_wip_id" {
  type    = string
  default = "vijay-server47-pool"

}

variable "circle_gcp_tf_state_bucket_name" {
  type    = string
  default = "vijay-tf-state-gcp"
}
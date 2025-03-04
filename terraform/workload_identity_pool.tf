
resource "google_iam_workload_identity_pool" "cci_server_472_wip_pool" {
  workload_identity_pool_id = var.gcp_wip_id
  display_name              = "vijay-server47-identity-pool"
  description               = "Identity pool for OIDC setup in CCI Server 4.7.2"
  disabled                  = false
}


resource "google_iam_workload_identity_pool_provider" "pool" {
  workload_identity_pool_id          = var.gcp_wip_id
  workload_identity_pool_provider_id = "${var.gcp_wip_id}-provider-id"
  display_name                       = "${var.gcp_wip_id}-provider-id"
  description                        = "Identity pool provider for OIDC setup in CCI Server 4.7.2"
  disabled                           = false
  attribute_mapping = {
    "attribute.project" = "assertion['${var.circleci_server_domain}/']"
    "attribute.org_id"  = "assertion.aud"
    "google.subject"    = "assertion.sub"
  }
  oidc {
    allowed_audiences = [var.circleci_oidc_org_id]
    issuer_uri        = "https://${var.circleci_server_domain}/org/${var.circleci_oidc_org_id}"
  }
  depends_on = [google_iam_workload_identity_pool.cci_server_472_wip_pool]
}
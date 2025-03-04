
import {
  id = "projects/${var.gcp_project_number}/locations/global/workloadIdentityPools/${var.workload_identity_pool_id}"
  to = google_iam_workload_identity_pool.cci_server_472_wip_pool
}


import {
  id = "projects/${var.gcp_project_number}/locations/global/workloadIdentityPools/${var.workload_identity_pool_id}/providers/${var.workload_pool_provider_id}"
  to = google_iam_workload_identity_pool_provider.pool
}

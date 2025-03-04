# Terraform GCP Service Account Setup

## Overview
This Terraform script provisions a Google Cloud Platform (GCP) service account, configures IAM roles, and sets up Workload Identity Pool for CircleCI integration. The infrastructure state is managed in a Google Cloud Storage (GCS) bucket.

## Resources Created using this config

- **Service Account:** A new GCP service account for Terraform usage. 
- **IAM Role Assignment:** Roles required to perform GCP functions via CircleCI are assigned to the service account.
- **Workload Identity Pool & Provider:** Configures workload identity for secure authentication with CircleCI. This template can be leveraged to allow more fine-grained permissions to users running CircleCI pipelines (At this time, the ability to restrict access based on an `organization-id`/`project-id`/`vcs-branch`/`context`/`user-id` is possible. 
- **GCS Backend:** For storing the Terraform state in a GCS bucket.

## Prerequisites

Before running the Terraform script, ensure the following are set up:

- [`gCloud CLI`](https://cloud.google.com/sdk/docs/install) is installed and configured.
- Access to a GCP project is available.
- Terraform (>=1.8.0) is installed.

Additionally, you can fork, modify, and reuse the provided [config.yml](https://github.com/AwesomeCICD/circleci-oidc-gcp-terraform/blob/main/.circleci/config.yml) file to apply the Terraform configuration via CircleCI.

## Variables
The Terraform script uses several variables. Below are the key ones:

| Variable Name | Type | Default | Description |
|--------------|------|---------|-------------|
| `gcp_project_id` | string | `dev-vijay-pandian` | The GCP project ID where resources will be created. |
| `gcp_service_account` | string | `vijay-tf-gcp-service-account` | The name of the GCP service account. |
| `workload_identity_pool_id` | string | `vijay-server47-pool` | The Workload Identity Pool ID. |
| `circleci_oidc_org_id` | string | `62ab4513-c6aa-4646-8189-a498fdbdb0d1` | The OIDC organization ID for CircleCI. |
| `circle_gcp_tf_state_bucket_name` | string | `vijay-tf-state-gcp` | The GCS bucket name for storing Terraform state. |

## Usage
1. Initialize Terraform:
   ```sh
   terraform init
   ```
2. Plan the infrastructure changes:
   ```sh
   terraform plan tfapply
   ```
3. Apply the Terraform configuration:
   ```sh
   terraform apply -auto-approve tfapply
   ```
4. Destroy the infrastructure if needed:
   ```sh
   terraform plan tfapply -destroy
   terraform destroy -auto-approve
   ```

## Outputs
| Output Name | Description |
|-------------|-------------|
| `service_account_attributes` | Contains details of the created service account (email, unique ID, name, etc.). |
| `bucket_name` | Outputs the name of the Terraform state bucket. |

## Architecture Diagram
```mermaid
graph TD;
  A[Terraform] -->|Provisions| B[GCP Service Account];
  B -->|Assigned Role| C[Google IAM Roles];
  B -->|Linked| D[Workload Identity Pool];
  D -->|OIDC Mapping| E[Workload Identity Pool Provider];
  E -->|Integrated| F[CircleCI OIDC Setup];
  B -->|Manages State| G[GCS Terraform State Bucket];
```

## Notes
- Ensure you have appropriate permissions to create and manage IAM roles.
- Workload Identity Pools allow external authentication, reducing the need for service account keys.
- The Terraform state is stored in a GCS bucket for team collaboration and remote state management.

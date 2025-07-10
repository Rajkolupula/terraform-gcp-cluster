# (Optional) Set the required Terraform version
terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }

  # Backend configuration to store Terraform state in a GCS bucket.
  # IMPORTANT: You must create this bucket before running 'terraform init'.
  backend "gcs" {
    bucket  = "your-terraform-state-bucket-name" # ⚠️ UPDATE THIS
    prefix  = "gke/cluster"
  }
}

# Configure the Google Cloud provider
provider "google" {
  project = "your-gcp-project-id" # ⚠️ UPDATE THIS
  region  = "us-central1"
}

# GKE Cluster Resource
resource "google_container_cluster" "primary" {
  name     = "primary-gke-cluster"
  location = "us-central1"

  # We are creating a separate node pool, so we remove the default one.
  remove_default_node_pool = true
  initial_node_count       = 1
}

# GKE Node Pool Resource
# A separate node pool for your workloads
resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    preemptible  = false
    machine_type = "e2-medium"

    # Standard OAuth scopes for GKE nodes
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# (Optional) Output the cluster endpoint and name
output "cluster_name" {
  description = "The name of the GKE cluster."
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "The public endpoint of the GKE cluster."
  value       = google_container_cluster.primary.endpoint
  sensitive   = true # The endpoint should be treated as sensitive data
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
}

provider "google" {
  # --- ⚠️ REQUIRED ---
  # Replace "your-gcp-project-id" with your actual Google Cloud Project ID.
  project = "inspired-rock-462006-e2"

  # --- Optional ---
  # You can change the region to your preferred location.
  region = "us-central1"
}

resource "google_container_cluster" "primary" {
  # --- ⚠️ REQUIRED ---
  # Provide a unique name for your GKE cluster.
  name = "my-gke-cluster"

  # --- Optional ---
  # The location (region or zone) for the cluster. This should match the
  # provider region for consistency.
  location = "us-central1"

  # The number of nodes to create in this cluster's default node pool.
  initial_node_count = 2

  # Configuration for the nodes in the default node pool.
  node_config {
    # The machine type to use for the nodes. "e2-medium" is a cost-effective choice.
    machine_type = "e2-medium"

    # Standard OAuth scopes required for GKE nodes to function correctly.
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
  backend "gcs" {
    bucket  = "your-terraform-state-bucket-name"
    prefix  = "gke-cluster"
  }
}

provider "google" {
  project = "your-gcp-project-id"
  region  = "us-central1"
}

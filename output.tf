output "cluster_name" {
  description = "The name of the created GKE cluster."
  value       = google_container_cluster.primary.name
}

# Output the public endpoint of the GKE cluster. This is used to connect to
# the cluster with tools like kubectl.
output "cluster_endpoint" {
  description = "The public endpoint of the GKE cluster."
  value       = google_container_cluster.primary.endpoint
  sensitive   = true # Marks the endpoint as sensitive to prevent it from being shown in logs.
}

# Output the cluster's Certificate Authority data, which is needed for kubectl.
output "cluster_ca_certificate" {
  description = "The cluster's root certificate authority data."
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

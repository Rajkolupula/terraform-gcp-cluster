output "vm_instance_public_ip" {
  description = "Public IP address of the VM instance"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "vm_instance_ssh_command" {
  description = "Command to SSH into the VM"
  value       = "gcloud compute ssh --zone ${google_compute_instance.vm_instance.zone} ${google_compute_instance.vm_instance.name}"
}

output "storage_bucket_url" {
  description = "URL of the created Google Cloud Storage bucket"
  value       = "https://console.cloud.google.com/storage/browser/${google_storage_bucket.bucket.name}"
}

output "docker_installation_status" {
  description = "Confirmation that Docker/Git were installed via startup script"
  value       = "Docker, Git, and Docker Compose were installed via metadata_startup_script."
}

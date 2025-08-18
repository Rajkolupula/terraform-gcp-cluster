provider "google" {
  project = "inspired-rock-462006-e2"  # Replace with your GCP project ID
  region  = "us-central1"      # Replace with your desired region
}

resource "google_compute_instance" "vm_instance" {
  name         = "my-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"  # Ubuntu 22.04 LTS
    }
  }

  network_interface {
    network = "default"
    access_config {}  # Assigns a public IP
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    # Update and install required packages
    sudo apt-get update -y
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        git

    # Install Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Add current user to Docker group (to run Docker without sudo)
    sudo usermod -aG docker $USER

    # Install Docker Compose (optional)
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    # Verify installations
    docker --version
    git --version
    docker-compose --version
  EOF

  tags = ["ssh"]  # Allow SSH via firewall rule
}

resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Allow SSH from anywhere (restrict in production)
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]  # Apply to instances with "ssh" tag
}

resource "google_storage_bucket" "bucket" {
  name          = "pk-bucket"  # Must be globally unique
  location      = "US"                     # Storage region
  force_destroy = true                     # Allows bucket deletion even if not empty
  uniform_bucket_level_access = true       # Enforces uniform bucket-level access
}

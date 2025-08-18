resource "google_compute_instance" "vm_instance" {
  name         = "my-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    # Install Docker, Git, etc. (existing setup)
    sudo apt-get update -y
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        git

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker $USER

    # Install Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    # ==== NEW: Docker Build & Push to Docker Hub ====
    # Create a sample Dockerfile
    cat <<EOL > Dockerfile
    FROM alpine:latest
    RUN echo "Hello from Terraform-built Docker image!" > /message
    CMD cat /message
    EOL

    # Log in to Docker Hub (replace credentials or use env variables)
    echo "${var.dockerhub_password}" | docker login --username "${var.dockerhub_username}" --password-stdin

    # Build and tag the image
    docker build -t ${var.dockerhub_username}/my-terraform-image:latest .

    # Push to Docker Hub
    docker push ${var.dockerhub_username}/my-terraform-image:latest

    # Cleanup (optional)
    docker logout
  EOF

  tags = ["ssh"]
}

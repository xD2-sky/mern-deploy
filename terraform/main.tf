resource "google_compute_network" "vpc" {
  name                    = "${var.vm_name}-vpc"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "allow_web" {
  name    = "${var.vm_name}-allow-web"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "${var.backend_port}"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    network = google_compute_network.vpc.name
    access_config {}
  }

  metadata = {
    startup-script = <<-SCRIPT
      #!/bin/bash
      exec >> /var/log/startup.log 2>&1
      echo "[$(date)] Startup script begin"

      apt-get update -y
      apt-get install -y docker.io docker-compose-plugin git
      systemctl enable docker
      systemctl start docker

      mkdir -p /app
      cd /app

      git clone https://github.com/${var.github_user}/${var.repo_deploy}.git
      git clone https://github.com/HuXn-WebDev/${var.repo_app}.git

      cp -r /app/${var.repo_app}/backend  /app/${var.repo_deploy}/backend
      cp -r /app/${var.repo_app}/frontend /app/${var.repo_deploy}/frontend

      cat > /app/${var.repo_deploy}/.env << ENV
      MONGO_URI=${var.mongo_uri}
      JWT_SECRET=${var.jwt_secret}
      PAYPAL_CLIENT_ID=${var.paypal_client_id}
      PORT=${var.backend_port}
      NODE_ENV=production
      ENV

      cd /app/${var.repo_deploy}
      sudo docker compose up --build -d

      echo "[$(date)] Startup script complete"
    SCRIPT
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  tags = [var.vm_name]
}

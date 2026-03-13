resource "google_compute_network" "vpc" {
  name                    = "${var.vm_name}-vpc"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "allow_web" {
  name    = "${var.vm_name}-allow-web"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", tostring(var.frontend_port), "443", tostring(var.backend_port)]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.vm_image
      size  = var.disk_size
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
      apt-get install -y ca-certificates curl gnupg git

      install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      chmod a+r /etc/apt/keyrings/docker.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

      apt-get update -y
      apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

      systemctl enable docker
      systemctl start docker

      mkdir -p ${var.clone_dir}
      cd ${var.clone_dir}

      git clone https://github.com/${var.github_user}/${var.repo_deploy}.git
      git clone https://github.com/HuXn-WebDev/${var.repo_app}.git

      cp -r ${var.clone_dir}/${var.repo_app}/. ${var.app_dir}/backend/
      cp -r ${var.clone_dir}/${var.repo_app}/frontend/. ${var.app_dir}/frontend/

      cat > ${var.app_dir}/.env << ENV
PORT=${var.backend_port}
MONGO_URI=mongodb://${var.mongo_host}:${var.mongo_port}/${var.mongo_db_name}
NODE_ENV=${var.node_env}
JWT_SECRET=${var.jwt_secret}
PAYPAL_CLIENT_ID=${var.paypal_client_id}
ENV

      cd ${var.app_dir}
      docker compose up --build -d

      echo "[$(date)] Startup script complete"
    SCRIPT
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  tags = [var.vm_name]
}

resource "google_cloudbuild_trigger" "deploy_trigger" {
  name            = "${var.vm_name}-deploy-trigger"
  project         = var.project_id
  location        = "global"
  service_account = "projects/${var.project_id}/serviceAccounts/${var.cloudbuild_sa}"

  github {
    owner = var.github_user
    name  = var.repo_deploy
    push {
      branch = "^${var.branch_name}$"
    }
  }

  filename = "cloudbuild.yaml"
}

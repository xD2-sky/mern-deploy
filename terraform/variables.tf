variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "project_number" {
  type        = string
  description = "GCP project number"
}

variable "region" {
  type    = string
  default = "asia-south1"
}

variable "zone" {
  type    = string
  default = "asia-south1-b"
}

variable "vm_name" {
  type    = string
  default = "ecommerce-vm"
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "vm_image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "disk_size" {
  type    = number
  default = 20
}

variable "github_user" {
  type = string
}

variable "repo_deploy" {
  type    = string
  default = "mern-deploy"
}

variable "app_dir" {
  type    = string
  default = "/app/mern-deploy"
}

variable "clone_dir" {
  type    = string
  default = "/app"
}

variable "branch_name" {
  type    = string
  default = "main"
}

variable "frontend_port" {
  type    = number
  default = 80
}

variable "backend_port" {
  type    = number
  default = 5000
}

variable "cloudbuild_sa" {
  type = string
}

variable "env_file_content" {
  type      = string
  sensitive = true
  description = "Full .env file contents — change this per project in gcp.tfvars"
}

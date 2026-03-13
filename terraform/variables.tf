variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "project_number" {
  type        = string
  description = "GCP Project Number"
}

variable "region" {
  type        = string
  description = "GCP Region"
  default     = "asia-south1"
}

variable "zone" {
  type        = string
  description = "GCP Zone"
  default     = "asia-south1-b"
}

variable "vm_name" {
  type        = string
  description = "VM instance name"
  default     = "ecommerce-vm"
}

variable "machine_type" {
  type        = string
  description = "VM machine type"
  default     = "e2-medium"
}

variable "vm_image" {
  type        = string
  description = "VM boot disk image"
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "disk_size" {
  type        = number
  description = "Boot disk size in GB"
  default     = 20
}

variable "github_user" {
  type        = string
  description = "YOUR GitHub username"
}

variable "repo_deploy" {
  type        = string
  description = "YOUR deployment repo name — contains app code + Dockerfiles"
  default     = "mern-deploy"
}

variable "app_dir" {
  type        = string
  description = "Directory where app runs on VM"
  default     = "/app/mern-deploy"
}

variable "clone_dir" {
  type        = string
  description = "Base directory for cloning repos"
  default     = "/app"
}

variable "branch_name" {
  type        = string
  description = "GitHub branch to deploy from"
  default     = "main"
}

variable "backend_port" {
  type        = number
  description = "Backend port"
  default     = 5000
}

variable "frontend_port" {
  type        = number
  description = "Frontend port"
  default     = 80
}

variable "node_env" {
  type        = string
  description = "Node environment"
  default     = "production"
}

variable "mongo_host" {
  type        = string
  description = "MongoDB host"
  default     = "mongodb"
}

variable "mongo_port" {
  type        = number
  description = "MongoDB port"
  default     = 27017
}

variable "mongo_db_name" {
  type        = string
  description = "MongoDB database name"
  default     = "ecommerce"
}

variable "jwt_secret" {
  type        = string
  sensitive   = true
  description = "JWT secret key"
}

variable "paypal_client_id" {
  type        = string
  sensitive   = true
  description = "PayPal client ID"
}

variable "cloudbuild_sa" {
  type        = string
  description = "Cloud Build service account email"
}

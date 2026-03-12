variable "project_id" {
  type        = string
  description = "GCP Project ID"
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

variable "github_user" {
  type        = string
  description = "GitHub username"
}

variable "repo_app" {
  type        = string
  description = "App repo name"
  default     = "MERN-E-Commerce-Store"
}

variable "repo_deploy" {
  type        = string
  description = "Deployment repo name"
  default     = "mern-deploy"
}

variable "mongo_uri" {
  type        = string
  sensitive   = true
  description = "MongoDB connection string"
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

variable "backend_port" {
  type        = number
  default     = 5000
  description = "Backend port"
}

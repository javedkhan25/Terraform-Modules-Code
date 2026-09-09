variable "location" {
  type        = string
  description = "Azure region"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
}

variable "postgres_admin_user" {
  type        = string
  description = "PostgreSQL admin username"
}

variable "postgres_admin_password" {
  type        = string
  description = "PostgreSQL admin password"
  sensitive   = true
}

variable "kubernetes_version" {
  type        = string
  description = "AKS Kubernetes version"
}

variable "postgresql_version" {}

variable "postgresql_sku_name" {}

variable "system_node_vm_size" {
  type = string
}

variable "frontend_node_vm_size" {
  type = string
}

variable "backend_node_vm_size" {
  type = string
}

variable "appgw_min_capacity" {}

variable "appgw_max_capacity" {}
variable "aks_name" {}
variable "location" {}
variable "rg_name" {}
variable "dns_prefix" {}

variable "kubernetes_version" {}

variable "aks_subnet_id" {}

variable "application_gateway_id" {}

variable "log_analytics_workspace_id" {}

variable "managed_identity_id" {}

variable "system_node_pool_name" {
  default = "system"
}

variable "system_node_vm_size" {
  type = string
}

variable "frontend_node_vm_size" {
  type = string
}

variable "backend_node_vm_size" {
  type = string
}

variable "tags" {
  type = map(string)
}


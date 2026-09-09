variable "scope" {
  description = "Resource ID where the role assignment will be applied"
  type        = string
}

variable "role" {
  description = "Azure RBAC role name"
  type        = string
}

variable "principal_id" {
  description = "Object ID of the user, service principal, managed identity, or AKS kubelet identity"
  type        = string
}
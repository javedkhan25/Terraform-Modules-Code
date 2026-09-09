variable "keyvault_name" {
  description = "Name of the Azure Key Vault"
  type        = string
}

variable "rg_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku_name" {
  description = "Key Vault SKU"
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention in days"
  type        = number
  default     = 90
}

variable "purge_protection_enabled" {
  description = "Enable purge protection"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable or disable public access"
  type        = bool
  default     = false
}

variable "network_default_action" {
  description = "Default network action"
  type        = string
  default     = "Deny"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
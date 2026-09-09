variable "postgresql_name" {
  description = "PostgreSQL Flexible Server name"
  type        = string
}

variable "database_name" {
  description = "PostgreSQL database name"
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

variable "vnet_id" {
  description = "Virtual network ID for private DNS link"
  type        = string
}

variable "delegated_subnet_id" {
  description = "Delegated subnet ID for PostgreSQL Flexible Server"
  type        = string
}

variable "private_dns_zone_name" {
  description = "Private DNS zone name for PostgreSQL"
  type        = string
  default     = "privatelink.postgres.database.azure.com"
}

variable "postgresql_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "16"
}

variable "administrator_login" {
  description = "PostgreSQL admin username"
  type        = string
}

variable "administrator_password" {
  description = "PostgreSQL admin password"
  type        = string
  sensitive   = true
}

variable "zone" {
  description = "Availability zone"
  type        = string
  default     = "1"
}

variable "storage_mb" {
  description = "Storage size in MB"
  type        = number
  default     = 32768
}

variable "sku_name" {
  description = "PostgreSQL SKU"
  type        = string
  default     = "GP_Standard_D2s_v3"
}

variable "backup_retention_days" {
  description = "Backup retention days"
  type        = number
  default     = 35
}

variable "geo_redundant_backup_enabled" {
  description = "Enable geo redundant backup"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
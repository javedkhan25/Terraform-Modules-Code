variable "vnet_name" {
  description = "Virtual Network Name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "rg_name" {
  description = "Resource Group Name"
  type        = string
}

variable "vnet_address_space" {
  description = "VNET Address Space"
  type        = list(string)

  default = [
    "10.0.0.0/16"
  ]
}

variable "aks_subnet_address_prefix" {
  description = "AKS Subnet CIDR"
  type        = list(string)

  default = [
    "10.0.1.0/24"
  ]
}

variable "appgw_subnet_address_prefix" {
  description = "Application Gateway Subnet CIDR"
  type        = list(string)

  default = [
    "10.0.2.0/24"
  ]
}

variable "private_endpoint_subnet_address_prefix" {
  description = "Private Endpoint Subnet CIDR"
  type        = list(string)

  default = [
    "10.0.3.0/24"
  ]
}

variable "postgresql_subnet_address_prefix" {
  description = "PostgreSQL Delegated Subnet CIDR"
  type        = list(string)

  default = [
    "10.0.4.0/24"
  ]
}

variable "tags" {
  description = "Common Tags"
  type        = map(string)

  default = {}
}
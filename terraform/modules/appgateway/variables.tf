variable "appgateway_name" {
  description = "Application Gateway name"
  type        = string
}

variable "waf_policy_name" {
  description = "WAF policy name"
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

variable "appgateway_subnet_id" {
  description = "Application Gateway subnet ID"
  type        = string
}

variable "waf_mode" {
  description = "WAF mode. Use Prevention for production"
  type        = string
  default     = "Prevention"
}

variable "owasp_version" {
  description = "OWASP rule set version"
  type        = string
  default     = "3.2"
}

variable "min_capacity" {
  description = "Minimum Application Gateway capacity"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum Application Gateway capacity"
  type        = number
  default     = 10
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
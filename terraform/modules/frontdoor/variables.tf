variable "resource_group_name" {}

variable "location" {}

variable "frontdoor_name" {}

variable "profile_sku" {
  default = "Premium_AzureFrontDoor"
}

variable "origin_hostname" {}

variable "tags" {
  type = map(string)
}

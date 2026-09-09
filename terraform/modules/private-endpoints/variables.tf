variable "private_endpoint_name" {
  type = string
}

variable "location" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "private_connection_resource_id" {
  type = string
}

variable "subresource_name" {
  type = string
}

variable "tags" {
  type = map(string)

  default = {}
}
resource "azurerm_virtual_network" "vnet" {

  name                = var.vnet_name
  resource_group_name = var.rg_name
  location            = var.location

  address_space = ["10.0.0.0/16"]

}

#AKS Subnet
resource "azurerm_subnet" "aks" {

  name                 = "aks-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = var.aks_subnet_address_prefix
}

#Application Gateway Subnet
resource "azurerm_subnet" "appgw" {

  name                 = "appgw-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = var.appgw_subnet_address_prefix
}

#Private Endpoint Subnet
resource "azurerm_subnet" "private_endpoint" {

  name                 = "private-endpoint-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = var.private_endpoint_subnet_address_prefix

  private_endpoint_network_policies = "Disabled"
}

#PostgreSQL Delegated Subnet
resource "azurerm_subnet" "postgresql" {

  name                 = "postgresql-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = var.postgresql_subnet_address_prefix

  service_endpoints = [
  "Microsoft.Storage"
  ]

  delegation {

    name = "postgres-delegation"

    service_delegation {

      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

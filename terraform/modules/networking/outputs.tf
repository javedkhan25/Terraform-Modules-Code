output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks.id
}

output "private_endpoint_subnet_id" {
  value = azurerm_subnet.private_endpoint.id
}

output "postgresql_subnet_id" {
  value = azurerm_subnet.postgresql.id
}

output "appgw_subnet_id" {
  value = azurerm_subnet.appgw.id
}

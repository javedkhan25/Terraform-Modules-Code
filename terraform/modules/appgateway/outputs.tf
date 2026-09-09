output "application_gateway_id" {
  value = azurerm_application_gateway.appgw.id
}

output "application_gateway_name" {
  value = azurerm_application_gateway.appgw.name
}

output "appgw_public_ip" {
  value = azurerm_public_ip.appgw_pip.ip_address
}

output "waf_policy_id" {
  value = azurerm_web_application_firewall_policy.waf_policy.id
}

output "appgw_id" {
  value = azurerm_application_gateway.appgw.id
}

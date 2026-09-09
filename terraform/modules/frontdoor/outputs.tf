output "frontdoor_endpoint" {
  value = azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name
}

output "frontdoor_profile_id" {
  value = azurerm_cdn_frontdoor_profile.fd.id
}

output "frontdoor_waf_policy_id" {
  value = azurerm_cdn_frontdoor_firewall_policy.waf.id
}

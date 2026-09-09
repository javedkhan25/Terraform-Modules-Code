#############################################################################
# RESOURCE GROUP
#############################################################################

output "resource_group_name" {
  value = module.resource_group.rg_name
}

#############################################################################
# AKS
#############################################################################

output "aks_name" {
  value = module.aks.aks_name
}

output "aks_id" {
  value = module.aks.aks_id
}

output "aks_private_fqdn" {
  value = module.aks.private_fqdn
}

#############################################################################
# ACR
#############################################################################

output "acr_name" {
  value = module.acr.acr_name
}

output "acr_login_server" {
  value = module.acr.acr_login_server
}

#############################################################################
# KEY VAULT
#############################################################################

output "keyvault_name" {
  value = module.keyvault.keyvault_name
}

output "keyvault_uri" {
  value = module.keyvault.keyvault_uri
}

#############################################################################
# POSTGRESQL
#############################################################################

output "postgresql_fqdn" {
  value = module.postgresql.postgresql_fqdn
}

output "database_name" {
  value = module.postgresql.database_name
}

#############################################################################
# APPLICATION GATEWAY
#############################################################################

output "application_gateway_name" {
  value = module.appgateway.application_gateway_name
}

output "waf_policy_id" {
  value = module.appgateway.waf_policy_id
}

#############################################################################
# MONITORING
#############################################################################

output "log_analytics_workspace_name" {
  value = module.monitoring.log_analytics_workspace_name
}

output "application_insights_id" {
  value = module.monitoring.application_insights_id
}
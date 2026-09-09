#############################################################################
# RESOURCE GROUP
#############################################################################

module "resource_group" {
  source = "../../modules/resource-group"

  resource_group_name = "rg-${var.environment}-aks-app"
  location            = var.location
}

#############################################################################
# NETWORKING
# VNET
# AKS Subnet
# App Gateway Subnet
# PostgreSQL Delegated Subnet
# Private Endpoint Subnet
#############################################################################

module "networking" {
  source = "../../modules/networking"

  rg_name   = module.resource_group.rg_name
  location  = var.location
  vnet_name = "vnet-${var.environment}-aks-app"

  tags = var.tags
}

#############################################################################
# AZURE CONTAINER REGISTRY (ACR)
#############################################################################

module "acr" {
  source = "../../modules/acr"

  acr_name = "acr${var.environment}aksapp001"

  rg_name  = module.resource_group.rg_name
  location = var.location

  tags = var.tags
}

#############################################################################
# MONITORING
# Log Analytics Workspace
# Application Insights
#############################################################################

module "monitoring" {
  source = "../../modules/monitoring"

  log_analytics_workspace_name = "law-${var.environment}-aks-app"
  application_insights_name    = "appi-${var.environment}-aks-app"

  rg_name  = module.resource_group.rg_name
  location = var.location

  tags = var.tags
}

#############################################################################
# KEY VAULT
#############################################################################

module "keyvault" {
  source = "../../modules/keyvault"

  keyvault_name = "kv-${var.environment}-aks-app01"

  rg_name  = module.resource_group.rg_name
  location = var.location

  public_network_access_enabled = false
  network_default_action        = "Deny"

  tags = var.tags
}

#############################################################################
# USER ASSIGNED MANAGED IDENTITY
#############################################################################

module "managed_identity" {
  source = "../../modules/managed-identity"

  identity_name = "mi-${var.environment}-aks-app"

  rg_name  = module.resource_group.rg_name
  location = var.location

  tags = var.tags
}

#############################################################################
# APPLICATION GATEWAY + WAF
#############################################################################

module "appgateway" {
  source = "../../modules/appgateway"

  appgateway_name = "agw-${var.environment}-aks-app"
  waf_policy_name = "waf-${var.environment}-aks-app"

  rg_name              = module.resource_group.rg_name
  location             = var.location
  appgateway_subnet_id = module.networking.appgw_subnet_id

  waf_mode      = "Prevention"
  owasp_version = "3.2"

  min_capacity = 2
  max_capacity = 10

  tags = var.tags
}

#############################################################################
# POSTGRESQL FLEXIBLE SERVER
#############################################################################

module "postgresql" {
  source = "../../modules/postgresql"

  postgresql_name = "psql-${var.environment}-aks-app"
  database_name   = "appdb"

  rg_name  = module.resource_group.rg_name
  location = var.location

  vnet_id             = module.networking.vnet_id
  delegated_subnet_id = module.networking.postgresql_subnet_id

  administrator_login    = var.postgres_admin_user
  administrator_password = var.postgres_admin_password

  postgresql_version = "16"

  sku_name   = "GP_Standard_D2s_v3"
  storage_mb = 32768

  backup_retention_days        = 35
  geo_redundant_backup_enabled = false

  tags = var.tags
}

#############################################################################
# AKS CLUSTER
# System Node Pool
# Frontend Node Pool
# Backend Node Pool
# AGIC Integration
# Log Analytics Integration
#############################################################################

module "aks" {
  source = "../../modules/aks"

  aks_name   = "aks-${var.environment}-app"
  dns_prefix = "aks-${var.environment}-app"

  rg_name  = module.resource_group.rg_name
  location = var.location

  kubernetes_version = var.kubernetes_version

  aks_subnet_id = module.networking.aks_subnet_id

  application_gateway_id = module.appgateway.application_gateway_id

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  managed_identity_id = module.managed_identity.identity_id

  system_node_vm_size   = "Standard_D2s_v5"
  frontend_node_vm_size = "Standard_D2s_v5"
  backend_node_vm_size = "Standard_D2s_v5"

  tags = var.tags

  depends_on = [
    module.appgateway,
    module.monitoring,
    module.managed_identity
  ]
}

#############################################################################
# ACR PULL ROLE
# Allows AKS to Pull Images from ACR
#############################################################################

module "acr_pull_role" {
  source = "../../modules/role-assignment"

  scope        = module.acr.acr_id
  role         = "AcrPull"
  principal_id = module.aks.kubelet_identity_object_id

  depends_on = [
    module.aks,
    module.acr
  ]
}

#############################################################################
# KEY VAULT SECRETS USER ROLE
# Allows AKS to Read Secrets from Key Vault
#############################################################################

module "keyvault_secret_user_role" {
  source = "../../modules/role-assignment"

  scope        = module.keyvault.keyvault_id
  role         = "Key Vault Secrets User"
  principal_id = module.aks.kubelet_identity_object_id

  depends_on = [
    module.aks,
    module.keyvault
  ]
}

#############################################################################
# AGIC CONTRIBUTOR ROLE
# Allows AGIC to Manage Application Gateway
#############################################################################

module "agic_contributor_role" {
  source = "../../modules/role-assignment"

  scope        = module.appgateway.application_gateway_id
  role         = "Contributor"
  principal_id = module.managed_identity.principal_id

  depends_on = [
    module.appgateway,
    module.managed_identity
  ]
}

#############################################################################
# AGIC NETWORK CONTRIBUTOR
# Allows AGIC to Access App Gateway Subnet
#############################################################################

module "agic_network_contributor" {
  source = "../../modules/role-assignment"

  scope        = module.networking.appgw_subnet_id
  role         = "Network Contributor"
  principal_id = module.managed_identity.principal_id

  depends_on = [
    module.networking,
    module.managed_identity
  ]
}

#############################################################################
# ACR PRIVATE ENDPOINT
#############################################################################

module "acr_private_endpoint" {

  source = "../../modules/private-endpoints"

  private_endpoint_name = "pe-acr-${var.environment}"

  rg_name  = module.resource_group.rg_name
  location = var.location

  subnet_id = module.networking.private_endpoint_subnet_id

  private_connection_resource_id = module.acr.acr_id

  subresource_name = "registry"

  tags = var.tags
}

#############################################################################
# KEY VAULT PRIVATE ENDPOINT
#############################################################################

module "keyvault_private_endpoint" {

  source = "../../modules/private-endpoints"

  private_endpoint_name = "pe-kv-${var.environment}"

  rg_name  = module.resource_group.rg_name
  location = var.location

  subnet_id = module.networking.private_endpoint_subnet_id

  private_connection_resource_id = module.keyvault.keyvault_id

  subresource_name = "vault"

  tags = var.tags

  depends_on = [
    module.keyvault,
    module.networking
  ]
}

#############################################################################
# Frontdoor
#############################################################################

module "frontdoor" {

  source = "../../modules/frontdoor"

  resource_group_name = module.resource_group.rg_name

  location = var.location

  frontdoor_name = "fd-prod-aks-app"

  origin_hostname = module.appgateway.appgw_public_ip

  tags = var.tags
}

#AGIC Identity Data Source
data "azurerm_kubernetes_cluster" "aks" {
  name                = module.aks.aks_name
  resource_group_name = module.resource_group.rg_name

  depends_on = [
    module.aks
  ]
}

#Reader Access To Resource Group
resource "azurerm_role_assignment" "agic_rg_reader" {

  scope = module.resource_group.rg_id

  role_definition_name = "Reader"

  principal_id = data.azurerm_kubernetes_cluster.aks.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}

#Contributor Access To Application Gateway
resource "azurerm_role_assignment" "agic_appgw_contributor" {

  scope = module.appgateway.appgw_id

  role_definition_name = "Contributor"

  principal_id = data.azurerm_kubernetes_cluster.aks.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}

#Network Contributor On App Gateway Subnet
resource "azurerm_role_assignment" "agic_subnet_network_contributor" {

  scope = module.networking.appgw_subnet_id

  role_definition_name = "Network Contributor"

  principal_id = data.azurerm_kubernetes_cluster.aks.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}

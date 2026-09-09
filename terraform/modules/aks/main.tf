resource "azurerm_kubernetes_cluster" "aks" {

  name                = var.aks_name
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = var.dns_prefix

  kubernetes_version = var.kubernetes_version

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  role_based_access_control_enabled = true

  azure_policy_enabled = true

  sku_tier = "Standard"

default_node_pool {

  name = var.system_node_pool_name

  vm_size = var.system_node_vm_size

  node_count = 1 

  vnet_subnet_id = var.aks_subnet_id

  temporary_name_for_rotation = "tmpnode"

  upgrade_settings {
    max_surge = "10%"
  }
}

  identity {

    type = "UserAssigned"

    identity_ids = [
      var.managed_identity_id
    ]
  }

  network_profile {

  network_plugin    = "azure"
  network_policy    = "azure"

  load_balancer_sku = "standard"
  outbound_type     = "loadBalancer"

  service_cidr   = "172.16.0.0/16"
  dns_service_ip = "172.16.0.10"
  }

  ingress_application_gateway {

    gateway_id = var.application_gateway_id
  }

  oms_agent {

    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  key_vault_secrets_provider {

    secret_rotation_enabled = true

    secret_rotation_interval = "2m"
  }

  tags = var.tags
}

#Frontend Node Pool
resource "azurerm_kubernetes_cluster_node_pool" "frontend_pool" {

  name                  = "frontend"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id

  vm_size = var.frontend_node_vm_size
  node_count           = 1
  vnet_subnet_id       = var.aks_subnet_id
  orchestrator_version = var.kubernetes_version

  mode = "User"

  node_labels = {
    workload = "frontend"
  }

  tags = var.tags

  upgrade_settings {
  max_surge = "10%"
  }
}

#Backend Node Pool
resource "azurerm_kubernetes_cluster_node_pool" "backend_pool" {

  name                  = "backend"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id

  vm_size = var.backend_node_vm_size
  node_count           = 1 
  vnet_subnet_id       = var.aks_subnet_id
  orchestrator_version = var.kubernetes_version

  mode = "User"

  node_labels = {
    workload = "backend"
  }

  tags = var.tags
  
  upgrade_settings {
  max_surge = "10%"
  }
}

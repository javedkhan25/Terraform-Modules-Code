location    = "Central India"
environment = "prod"

kubernetes_version = "1.35.6"

tags = {
  environment = "prod"
  project     = "react-springboot-aks"
  owner       = "devops-team"
}

postgresql_version   = "16"

postgresql_sku_name  = "GP_Standard_D2s_v3"

system_node_vm_size   = "Standard_D2s_v5"

frontend_node_vm_size = "Standard_D2s_v5"

backend_node_vm_size  = "Standard_D2s_v5"

appgw_min_capacity = 2

appgw_max_capacity = 10
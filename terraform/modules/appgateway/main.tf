resource "azurerm_public_ip" "appgw_pip" {
  name                = "${var.appgateway_name}-pip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_web_application_firewall_policy" "waf_policy" {
  name                = var.waf_policy_name
  resource_group_name = var.rg_name
  location            = var.location

  policy_settings {
    enabled                     = true
    mode                        = var.waf_mode
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = var.owasp_version
    }
  }

  custom_rules {
    name      = "BlockBadBots"
    priority  = 10
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RequestHeaders"
        selector      = "User-Agent"
      }

      operator           = "Contains"
      negation_condition = false
      match_values       = ["sqlmap", "nikto", "nmap"]
      transforms         = ["Lowercase"]
    }

    action = "Block"
  }

  tags = var.tags
}

resource "azurerm_application_gateway" "appgw" {
  name                = var.appgateway_name
  resource_group_name = var.rg_name
  location            = var.location

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.appgateway_subnet_id
  }

  frontend_port {
    name = "httpPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appGatewayFrontendIp"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name = "defaultBackendPool"
  }

  backend_http_settings {
    name                  = "defaultHttpSettings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "httpListener"
    frontend_ip_configuration_name = "appGatewayFrontendIp"
    frontend_port_name             = "httpPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "defaultRoutingRule"
    rule_type                  = "Basic"
    http_listener_name         = "httpListener"
    backend_address_pool_name  = "defaultBackendPool"
    backend_http_settings_name = "defaultHttpSettings"
    priority                   = 100
  }

  firewall_policy_id = azurerm_web_application_firewall_policy.waf_policy.id

  tags = var.tags

  depends_on = [
    azurerm_public_ip.appgw_pip,
    azurerm_web_application_firewall_policy.waf_policy
  ]

# AGIC dynamically manages Application Gateway backend pools, listeners, routing rules, health probes, and tags based on Kubernetes Ingress resources.
# Since these resources are managed by AGIC, Terraform must ignore changes to them to prevent configuration drift and unnecessary updates.

# The lifecycle block is added because, during each `terraform apply`, Terraform attempts to reconcile the Application Gateway configuration with the Terraform state.
# However, Terraform does not manage the AGIC-generated configurations. These configurations are dynamically created and updated by AGIC after it is deployed and Kubernetes Ingress resources are applied.

# As a result, Terraform detects these AGIC-managed configurations as drift and tries to remove or modify them during subsequent deployments.

# To prevent Terraform from deleting or modifying AGIC-managed configurations, the lifecycle `ignore_changes` block is added for the properties listed below.

lifecycle {
  ignore_changes = [
    tags,
    backend_address_pool,
    backend_http_settings,
    http_listener,
    probe,
    request_routing_rule,
    url_path_map
  ]
}
}
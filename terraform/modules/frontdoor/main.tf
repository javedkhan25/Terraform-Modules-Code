#Front Door Profile
resource "azurerm_cdn_frontdoor_profile" "fd" {
  name                = var.frontdoor_name
  resource_group_name = var.resource_group_name
  sku_name            = var.profile_sku

  tags = var.tags
}

#Endpoint
resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                     = "${var.frontdoor_name}-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
}

#Origin Group
resource "azurerm_cdn_frontdoor_origin_group" "origin_group" {
  name                     = "aks-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    interval_in_seconds = 60
    path                = "/"
    protocol            = "Https"
    request_type        = "GET"
  }
}

# Application Gateway Origin

resource "azurerm_cdn_frontdoor_origin" "appgw" {
  name                          = "appgateway-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id

  enabled                        = true
  host_name                      = var.origin_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.origin_hostname
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = false
}

#Route
resource "azurerm_cdn_frontdoor_route" "route" {

  name                          = "default-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id

  cdn_frontdoor_origin_ids = [
    azurerm_cdn_frontdoor_origin.appgw.id
  ]

  supported_protocols = [
    "Http",
    "Https"
  ]

  patterns_to_match = [
    "/*"
  ]

  forwarding_protocol = "MatchRequest"
  https_redirect_enabled = true
}

# Front Door WAF Policy
resource "azurerm_cdn_frontdoor_firewall_policy" "waf" {

  name                = replace("${var.frontdoor_name}waf", "-", "") 
  resource_group_name = var.resource_group_name
  sku_name            = "Premium_AzureFrontDoor"

  enabled             = true
  mode                = "Prevention"

  managed_rule {
    type    = "Microsoft_DefaultRuleSet"
    version = "2.1"
    action = "Block"
  }

  tags = var.tags
}

# Attach WAF to Front Door
resource "azurerm_cdn_frontdoor_security_policy" "security" {
  name                     = "frontdoor-security"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.waf.id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
        }

        patterns_to_match = ["/*"]
      }
    }
  }
}

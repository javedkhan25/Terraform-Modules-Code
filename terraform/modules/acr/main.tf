resource "azurerm_container_registry" "acr" {

  name                = var.acr_name
  resource_group_name = var.rg_name
  location            = var.location
  tags 		      = var.tags

  sku           = "Premium"
  admin_enabled = false
  
  // lifecycle {
  // prevent_destroy = true
  // }

}

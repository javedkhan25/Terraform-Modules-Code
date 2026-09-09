resource "azurerm_user_assigned_identity" "identity" {
  name                = var.identity_name
  resource_group_name = var.rg_name
  location            = var.location

  tags = var.tags
}
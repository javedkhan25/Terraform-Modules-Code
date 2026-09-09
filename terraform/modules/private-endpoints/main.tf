resource "azurerm_private_endpoint" "private_endpoint" {

  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.rg_name

  subnet_id = var.subnet_id

  private_service_connection {

    name = "${var.private_endpoint_name}-psc"

    private_connection_resource_id = var.private_connection_resource_id

    subresource_names = [
      var.subresource_name
    ]

    is_manual_connection = false
  }

  tags = var.tags
}
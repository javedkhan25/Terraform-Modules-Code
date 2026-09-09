resource "azurerm_private_dns_zone" "postgres_dns" {
  name                = var.private_dns_zone_name
  resource_group_name = var.rg_name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dns_link" {
  name                  = "${var.postgresql_name}-dns-link"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_dns.name
  virtual_network_id    = var.vnet_id

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = var.postgresql_name
  resource_group_name    = var.rg_name
  location               = var.location
  version                = var.postgresql_version
  delegated_subnet_id    = var.delegated_subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.postgres_dns.id
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  zone                   = var.zone

  storage_mb = var.storage_mb
  sku_name   = var.sku_name

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  public_network_access_enabled = false

  tags = var.tags

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.postgres_dns_link
  ]

  // lifecycle {
  // prevent_destroy = true
  // }
}

resource "azurerm_postgresql_flexible_server_database" "database" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}
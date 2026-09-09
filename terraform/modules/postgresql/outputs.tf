output "postgresql_server_id" {
  value = azurerm_postgresql_flexible_server.postgres.id
}

output "postgresql_fqdn" {
  value = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.database.name
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.postgres_dns.id
}
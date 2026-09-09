output "identity_id" {
  description = "User Assigned Managed Identity ID"
  value       = azurerm_user_assigned_identity.identity.id
}

output "identity_name" {
  description = "User Assigned Managed Identity Name"
  value       = azurerm_user_assigned_identity.identity.name
}

output "principal_id" {
  description = "User Assigned Managed Identity Principal ID"
  value       = azurerm_user_assigned_identity.identity.principal_id
}

output "client_id" {
  description = "User Assigned Managed Identity Client ID"
  value       = azurerm_user_assigned_identity.identity.client_id
}

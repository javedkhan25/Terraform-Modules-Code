#############################################################################
# AKS Cluster Information
#############################################################################

output "aks_id" {
  description = "AKS Cluster ID"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "aks_name" {
  description = "AKS Cluster Name"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "fqdn" {
  description = "AKS API Server FQDN"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

output "node_resource_group" {
  description = "AKS Managed Resource Group"
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

#############################################################################
# Identity Outputs
#############################################################################

output "aks_principal_id" {
  description = "AKS Managed Identity Principal ID"
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

output "kubelet_identity_object_id" {
  description = "Kubelet Identity Object ID"
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

output "kubelet_identity_client_id" {
  description = "Kubelet Identity Client ID"
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].client_id
}

#############################################################################
# OIDC and Workload Identity
#############################################################################

output "oidc_issuer_url" {
  description = "OIDC Issuer URL"
  value       = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}

#############################################################################
# Network Information
#############################################################################

output "private_fqdn" {
  description = "Private AKS FQDN"
  value       = azurerm_kubernetes_cluster.aks.private_fqdn
}

#############################################################################
# Kube Config
#############################################################################

output "host" {
  description = "Kubernetes API Server"
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].host
  sensitive   = true
}

output "client_certificate" {
  description = "Client Certificate"
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
  sensitive   = true
}

output "client_key" {
  description = "Client Key"
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].client_key
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Cluster CA Certificate"
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate
  sensitive   = true
}

output "kube_config_raw" {
  description = "Raw Kube Config"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}
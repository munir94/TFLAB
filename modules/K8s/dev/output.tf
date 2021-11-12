output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks1.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks1.kube_config_raw

  sensitive = true
} 

output "cluster_ca_certificate" {
    value = azurerm_kubernetes_cluster.aks1.kube_config.0.cluster_ca_certificate
}

output "client_key" {
    value = azurerm_kubernetes_cluster.aks1.kube_config.0.client_key
}

output "host" {
    value = azurerm_kubernetes_cluster.aks1.kube_config.0.host
}

output "aks-rg" {
  value = azurerm_resource_group.aks-rg
  
}
output "aks-name" {
  value = azurerm_kubernetes_cluster.aks1.name
}
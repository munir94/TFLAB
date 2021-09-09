#  output "akssubnet_id" {
# value = azurerm_subnet.prod-aks-subnet.id
#  }

output "vnet_subnets" {
  description = "The ids of subnets created inside the newl vNet"
  value       = azurerm_subnet.subnet.*.id
}
#  output "akssubnet_id" {
# value = azurerm_subnet.prod-aks-subnet.id
#  }

output "vnet_subnets" {
  description = "The ids of subnets created inside the newl vNet"
  value       = azurerm_subnet.subnet.*.id
}

output "vnet-rg" {
  description = "RG that contains the vNET"
  value       = azurerm_resource_group.vnet-rg.name
}

output "vnet-id" {
  description = "ID of the vnet vNET"
  value       = azurerm_virtual_network.vnet.id
}
output "vnet-name" {
  description = "Name of the vnet vNET"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_subnets-name" {
  description = "The ids of subnets created inside the newl vNet"
  value       = azurerm_subnet.subnet.*.name
}
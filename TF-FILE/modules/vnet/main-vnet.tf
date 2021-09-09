 
resource "azurerm_resource_group" "vnet-rg" {
  name = var.vnet-rg 
  location = var.vnet-location
  
  tags = {
    Environment = "Managed by TF"
  }
}

 resource "azurerm_virtual_network" "vnet" {
     name                 = var.vnet-name
     resource_group_name  = azurerm_resource_group.vnet-rg.name
     location             = azurerm_resource_group.vnet-rg.location
     address_space        = var.vnet-range
    dns_servers           = var.vnet-dns
     
 }


 resource "azurerm_subnet" "subnet" {
   count                   = length(var.subnets-name)
   name                    = var.subnets-name[count.index]
   virtual_network_name    = azurerm_virtual_network.vnet.name
   resource_group_name     = azurerm_resource_group.vnet-rg.name
   address_prefixes        = [var.subnets-range[count.index]]  

   #needed [[]] to be treated as one 
   

 }

  locals {
  azurerm_subnets = {
    for index, subnet in azurerm_subnet.subnet :
    subnet.name => subnet.id
  }
}

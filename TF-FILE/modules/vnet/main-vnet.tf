 
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


#  #import exisiting subnet 

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
#  resource "azurerm_subnet_network_security_group_association" "app-subnet" {
#    subnet_id = azurerm_subnet.prod-app-subnet.id
#    network_security_group_id = azurerm_network_security_group.nsg-app.id
#  }

#  resource "azurerm_subnet" "prod-web-subnet" {
#    name = "PROD-WEB-SUBNET"
#    virtual_network_name = azurerm_virtual_network.prod-vnet.name
#    resource_group_name = data.terraform_remote_state.prod-rg.outputs.rg-name
#    address_prefixes = [ "192.168.1.0/28" ]
#  }
#  resource "azurerm_subnet" "prod-db-subnet" {
#    name = "PROD-DB-SUBNET"
#    virtual_network_name = azurerm_virtual_network.prod-vnet.name
#    resource_group_name = data.terraform_remote_state.prod-rg.outputs.rg-name
#    address_prefixes = [ "192.168.1.32/28" ]
   
#  }
#  resource "azurerm_subnet" "prod-mgmt-subnet" {
#    name = "PROD-MGMT-SUBNET"
#    resource_group_name = data.terraform_remote_state.prod-rg.outputs.rg-name
#    virtual_network_name = azurerm_virtual_network.prod-vnet.name
#    address_prefixes = [ "192.168.1.48/28" ]
   
#   }

#    resource "azurerm_subnet" "prod-aks-subnet" {
#    name = "PROD-AKS-SUBNET"
#    resource_group_name = data.terraform_remote_state.prod-rg.outputs.rg-name
#    virtual_network_name = azurerm_virtual_network.prod-vnet.name
#    address_prefixes = [ "172.16.0.0/22" ]
   
#   }
# resource "azurerm_network_security_group" "nsg-app" {
#   name = "NSG-APP"
#   location = data.terraform_remote_state.prod-rg.outputs.rg-dc
#   resource_group_name = data.terraform_remote_state.prod-rg.outputs.rg-name
# }


# resource "azurerm_network_security_group" "nsg-web" {
#   name = "NSG-WEB"
#    location = data.terraform_remote_state.prod-rg.outputs.rg-dc
#   resource_group_name = data.terraform_remote_state.prod-rg.outputs.rg-name
# }
# resource "azurerm_network_security_group" "nsg-db" {
#   name = "NSG-DB"
#    location = data.terraform_remote_state.prod-rg.outputs.rg-dc
#   resource_group_name = data.terraform_remote_state.prod-rg.outputs.rg-name
# }
# resource "azurerm_network_security_group" "nsg-mgmt" {
#   name = "NSG-MGMT"
#    location = data.terraform_remote_state.prod-rg.outputs.rg-dc
#   resource_group_name = data.terraform_remote_state.prod-rg.outputs.rg-name
# }




  

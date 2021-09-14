resource "azurerm_virtual_network_peering" "peering" {
  name                      = var.peer-name
  resource_group_name       = var.peer-rg
  virtual_network_name      = var.source-vnet-name
  remote_virtual_network_id = var.target-vnet-id
  use_remote_gateways       = lower(var.use-remote-gw)
  #depends_on                = var.vnet-creation 
}
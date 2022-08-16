resource "azurerm_resource_group" "sa-rg" {
    name = var.sa-rg
    location = var.sa-loc

    tags = {
      "Usage" = "Boot Diagnostic"
    }
  
}
resource "azurerm_storage_account" "boot-sa" {
    name = lower(var.saname)
    resource_group_name = azurerm_resource_group.sa-rg.name
    location = azurerm_resource_group.sa-rg.location
    account_tier = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  count                = length(var.sacontainer)
  name                 = var.sacontainer[count.index]
  storage_account_name = azurerm_storage_account.boot-sa.name
}

 locals {
  azurerm_storage_containers = {
    for index, container in azurerm_storage_container.container :
    container.name => container.id
  }
 }
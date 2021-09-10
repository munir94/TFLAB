resource "azurerm_resource_group" "saboot-rg" {
    name = var.saboot-rg
    location = var.saboot-loc

    tags = {
      "Usage" = "Boot Diagnostic"
    }
  
}
resource "azurerm_storage_account" "boot-sa" {
    name = lower(var.boot-sa)
    resource_group_name = azurerm_resource_group.saboot-rg.name
    location = azurerm_resource_group.saboot-rg.location
    account_tier = "Standard"
    account_replication_type = "LRS"
}

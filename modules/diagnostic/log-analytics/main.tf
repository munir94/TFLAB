resource "azurerm_resource_group" "law-rg" {
  name     = var.law-rg
  location = var.law-loc
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = var.law-name
  location            = azurerm_resource_group.law-rg.location
  resource_group_name = azurerm_resource_group.law-rg.name
  sku                 = var.law-sku
  retention_in_days   = var.law-retention
 
}
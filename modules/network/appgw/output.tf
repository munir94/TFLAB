output "appgwid" {
    value = azurerm_application_gateway.agw.id
  
}
output "appgwname" {
    value = azurerm_application_gateway.agw.name
  
}
output "appgwrg" {
  value = azurerm_resource_group.ag-rg.id
}
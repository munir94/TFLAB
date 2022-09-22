output "boot-addr" {
  value = azurerm_storage_account.boot-sa.primary_blob_endpoint
}

output "containerid" {
  value = azurerm_storage_container.container.*.resource_manager_id
}
output "containername" {
  value = azurerm_storage_container.container.*.name
}
output "sa-rg" {
  value = azurerm_resource_group.sa-rg.name
}
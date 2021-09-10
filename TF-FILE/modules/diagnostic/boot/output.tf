output "boot-addr" {
  value = azurerm_storage_account.boot-sa.primary_blob_endpoint
}
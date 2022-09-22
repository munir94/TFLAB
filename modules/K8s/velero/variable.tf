# Credentials
variable "azure_client_id" {
  description = "The Azure Client ID to use to access the storage account"
}
variable "azure_client_secret" {
  description = "The Client Secret to use for the storage backend"
}

variable "azure_resource_group" {
  description = "The Resource Group in where the Client ID resides"
}

variable "azure_subscription_id" {
  description = "The Azure Subscription ID"
}

variable "azure_tenant_id" {
  description = "The Azure Tenant ID"
}

# Backup Storage Location

variable "backup_storage_resource_group" {
  description = "The resource group containing the bucket"
}
variable "backup_storage_account" {
  description = "The storage account containing the bucket"
}
variable "backup_storage_bucket" {
  description = "The bucket to use for backing up"
}
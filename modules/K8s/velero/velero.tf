
/*
reference 
1. https://github.com/StatCan/terraform-kubernetes-velero/blob/master/main.tf
*/

resource "kubernetes_namespace" "velero" {
    metadata {
        name = "velero"
    }
}

resource "helm_release" "velero" {
  name = "velero"
  namespace = kubernetes_namespace.velero.metadata[0].name
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart = "velero"


# Backup Storage Location
  set {
    name  = "configuration.backupStorageLocation.bucket"
    value = var.backup_storage_bucket
  }

  set {
    name  = "configuration.backupStorageLocation.config.resourceGroup"
    value = var.backup_storage_resource_group
  }

  set {
    name  = "configuration.backupStorageLocation.config.storageAccount"
    value = var.backup_storage_account
  }



   set {
    name  = "credentials.secretContents.cloud"
    value = <<EOF
          AZURE_CLIENT_ID: ${var.azure_client_id}
          AZURE_CLIENT_SECRET: ${var.azure_client_secret}
          AZURE_RESOURCE_GROUP: ${var.azure_resource_group}
          AZURE_SUBSCRIPTION_ID: ${var.azure_subscription_id}
          AZURE_TENANT_ID: ${var.azure_tenant_id}
EOF
  }



}
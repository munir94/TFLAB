#https://carlos.mendible.com/2021/04/30/deploy-aks--kubecost-with-terraform/
resource "kubernetes_namespace" "kubecost" {
  metadata {
    annotations = {
      name = "kubecost-annotation"
    }
    name = "kubecost"
  }
}


# Create kubecost custom role
   resource "azurerm_role_definition" "kubecost" {
   name        = "kubecost_rate_card_query"
   scope       = "/subscriptions/${var.sub-id}"
   description = "kubecost Rate Card query role"
 
  permissions {
    actions     = [
     "Microsoft.Compute/virtualMachines/vmSizes/read",
      "Microsoft.Resources/subscriptions/locations/read",
      "Microsoft.Resources/providers/read",
      "Microsoft.ContainerService/containerServices/read",
      "Microsoft.Commerce/RateCard/read",
    ]
    not_actions = []
  }

  assignable_scopes = [
    "/subscriptions/${var.sub-id}"
  ]
}

#Assign Role to SPN at Subcription level 
resource "azurerm_role_assignment" "kubecost" {
  scope                = "/subscriptions/${var.sub-id}"
  role_definition_name = azurerm_role_definition.kubecost.name
  principal_id         = var.spn-id
}

resource "kubernetes_secret" "kubecost_sec" {
  metadata {
    name      = "kubecost-sec"
    namespace = kubernetes_namespace.kubecost.metadata[0].name
  }
  data = {
      "cloud-integration.json" = "\r\n{\r\n    \"azure\": [\r\n        {\r\n          \"azureSubscriptionID\": \"${var.sub-id}\",\r\n          \"azureStorageAccount\": \"${var.saname}\",\r\n          \"azureStorageAccessKey\": \"${var.sakey}\",\r\n          \"azureStorageContainer\": \"${var.sacontainer}\",\r\n          \"azureContainerPath\": \"${var.sapath}\",\r\n          \"azureCloud\": \"${var.azcloud}\"\r\n        }\r\n    ]\r\n}"
   
  }
  type = "Opaque"
}



resource "helm_release" "kubecost-helm"{
   name       = "kubecost"
   repository = "https://kubecost.github.io/cost-analyzer/"
   chart      = "cost-analyzer"
   namespace = kubernetes_namespace.kubecost.metadata[0].name
   

    set {
    name  = "kubecostToken"
    value = "aGVsbUBrdWJlY29zdC5jb20=xm343yadf98"
    #value = "YWJkdWwubXVuaXI5NEBvdXRsb29rLmNvbQ==xm343yadf98"
   } 
  # Set the cluster name
 set {
    name  = "kubecostProductConfigs.clusterName"
    value = var.aks-name
  }
 set {
    name  = "ingress.enabled"
    value = true
  }
  set {
    name  = "Values.ingress.hosts"
    value = "kubecost.munirtajudin.xyz"
  }
 

 # out of cluster 

#  set {
#     name  = "Values.kubecostProductConfigs.azureStorageAccount"
#     value = var.saname
#   }
#   set {
#     name  = "Values.kubecostProductConfigs.azureStorageAccessKey"
#     value = var.sakey
#   }
  
#    set {
#     name  = "Values.kubecostProductConfigs.azureStorageContainer"
#     value = var.sacontainer
#   }
#    set {
#     name  = "Values.kubecostProductConfigs.azureStorageCreateSecret"
#     value = true
#   }

  # Azure Subscription ID
  set {
    name  = "kubecostProductConfigs.azureSubscriptionID"
    value = var.sub-id
  }

  # Azure Client ID
  set {
    name  = "kubecostProductConfigs.azureClientID"
    value = var.client-id
  }

  # Azure Client Password
  set {
    name  = "kubecostProductConfigs.azureClientPassword"
    value = var.client-sec
  }

  # Azure Tenant ID
  set {
    name  = "kubecostProductConfigs.azureTenantID"
    value = var.tenant-id
  }

  #Set the currency
  set {
    name  = "kubecostProductConfigs.currencyCode"
    value = "USD"
  }
# 
  # Set the region
   set {
    name  = "kubecostProductConfigs.azureBillingRegion"
    value = "US"
  }
  set {
    name  = "kubecostProductConfigs.azureOfferDurableID"
    value = "MS-AZR-0029P" 
  }
  # Generate a secret based on the Azure configuration provided below
  set {
    name  = "kubecostProductConfigs.createServiceKeySecret"
    value = true
  }


# #     #http://localhost:9090/model/etl/cloudUsage/rebuild?commit=true
# #     #https://json2yaml.com/
# #     #https://www.hcl2json.com/

  set {
    name  = "kubecostProductConfigs.cloudIntegrationSecret"
    value = kubernetes_secret.kubecost_sec.metadata[0].name
  }
}


#https://carlos.mendible.com/2021/04/30/deploy-aks--kubecost-with-terraform/
resource "kubernetes_namespace" "kubecost" {
  metadata {
    annotations = {
      name = "kubecost-annotation"
    }
    name = "kubecost"
  }
}
resource "helm_release" "kubecost-helm" {
   name       = "kubecost"
   repository = "https://kubecost.github.io/cost-analyzer/"
   chart      = "cost-analyzer"
   namespace = kubernetes_namespace.kubecost.metadata[0].name
   

    set {
    name  = "kubecostToken"
    value = "aGVsbUBrdWJlY29zdC5jb20=xm343yadf98"
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
    name  = "ingress.hosts"
    value = "kubecost.munirtajudin.xyz"
  }
 

 # Set the currency
#  set {
#     name  = "kubecostProductConfigs.currencyCode"
#     value = "EUR"
#   }
# 
#   # Set the region
#   set {
#     name  = "kubecostProductConfigs.azureBillingRegion"
#     value = "NL"
#   }
  
  # Generate a secret based on the Azure configuration provided below
  # set {
  #   name  = "kubecostProductConfigs.createServiceKeySecret"
  #   value = true
  # }

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
   set {
    name  = "kubecostProductConfigs.azureOfferDurableID"
    value = "MS-AZR-0029P"
  }

}

# resource "kubernetes_ingress_v1" "kubecost" {

#     #depends_on = [kubernetes_namespace.nginx1]

#     metadata {
#         name = "kubecost"
#         namespace = kubernetes_namespace.kubecost.metadata[0].name
#     }
    
#     spec {
#         rule {
#             host = "${var.host}.munirtajudin.xyz"
            
#             http {
#                 path {
#                     path = "/"
#                     backend {
#                         service {
#                             name = "kubecost-cost-analyzer"
#                             port {
#                                 number = 9090
                              
#                             }
                            
#                         }
#                     }
#                 }
#             }
#         }
#     }
# }

# resource "kubernetes_ingress_v1" "kubecost" {

#     depends_on = [kubernetes_namespace.kubecost]

#     metadata {
#         name = "kubecost"
#         namespace = kubernetes_namespace.kubecost.metadata[0].name
#     }
#     spec {
#         rule {

#             host = "kubecost.munirtajudin.xyz"

#             http {

#                 path {
#                     path = "/"
#                    path_type = "prefix"
#                     backend {
#                         service {
#                             name = "kubecost-cost-analyzer"
#                             port {
#                                 number = 9090
#                             }
#                         }
#                     }

#                 }
#             }
#         }
#     }
# }




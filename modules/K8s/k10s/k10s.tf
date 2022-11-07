#! https://docs.kasten.io/install/advanced.html#advanced-sa
# https://artifacthub.io/packages/helm/kasten/k10
resource "kubernetes_namespace" "k10" {
  metadata {
    annotations = {
      name = "k10-annotation"
    } 
    name = "kasten-io"

}
}
# resource "helm_release" "kasten-helm"{
#    name       = "kasten"
#    repository = "https://charts.kasten.io/"
#   chart      = "kasten"
#    namespace = kubernetes_namespace.k10.metadata[0].name
# }

resource "null_resource" "k10-helm-update" {
  provisioner "local-exec" {
    command = "helm repo update"
    interpreter = ["cmd", "-Command"]
  }
}
resource "helm_release" "k10-helm"{
   name       = "k10"
   repository = "kasten"
   chart      = "k10"
   namespace = kubernetes_namespace.k10.metadata[0].name
   #helm search hub k10

    set {
    name  = "secrets.azureTenantId"
    value = var.tenant_id
   
   } 
     set {
    name  = "secrets.azureClientId"
    value = var.client_id
    
   } 
      set {
    name  = "secrets.azureClientSecret"
    value = var.client_sec
  
   } 
  set {
    name  = "externalGateway.create"
    value = "true"
  }
  #! Authentication 
  # set {
  #   name  = "auth.tokenAuth.enabled"
  #   value = "true"
  # }
   set {
    name  = "auth.basicAuth.enabled"
    value = "true"
  }
   set {
    name  = "auth.basicAuth.htpasswd"
    value = "k10aks:$2y$10$/NA1WvLoq0nhCm4lidL9pe8l4kMY/YlaJgNE/W7TjVVdUenuFDLOe"
  }
  set {
    name  = "eula.accept"
    value = true
  }
  set {
    name  = "eula.company"
    value = "Company"
  }
  set {
    name  = "eula.email"
    value = "a@a.com"
  }
  set {
    name  = "global.persistence.storageClass"
    value = "default"
  }

set {
  name = "grafana.enabled"
  value = var.grafana
}
 
   set {
    name = "ingress.create"
    value = true
   }
   set {
    name = "ingress.class"
    value = "nginx"
   }
set {
  name = "ingress.host"
  value = "kasten.munirtajudin.xyz"
}


}
#    helm install k10 kasten/k10 --namespace=kasten-io \
#     --set secrets.azureTenantId=<tenantID> \
#     --set secrets.azureClientId=<azureclient_id> \
#     --set secrets.azureClientSecret=<azureclientsecret>
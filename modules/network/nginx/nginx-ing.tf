#https://github.com/Azure-Terraform/terraform-azurerm-kubernetes-nginx-ingress

# resource "azurerm_resource_group" "nginx-rg" {
#   name     = var.ngxrg
#   location = var.loc
# }


resource "azurerm_public_ip" "ngxip" {
  name                = var.ngxip
  resource_group_name = "MC_${var.aks-rg}_${var.aks-name}_${var.loc}"
  location            = var.loc
  allocation_method   = "Static"
  sku = "Standard"
  sku_tier = "Regional"
  availability_zone = "Zone-Redundant"
}

# resource "azurerm_role_assignment" "ngx-ra01" {
#   scope                = azurerm_public_ip.ngxip.resource_group_name
#   role_definition_name = "Network Contributor"
#   principal_id         = var.aksngx-spnid
  
# }

resource "kubernetes_namespace" "nginx" {
    metadata {
        name = "nginx-ingress"
    }
}
resource "null_resource" "helm-update" {
  provisioner "local-exec" {
    command = "helm repo update"
  }
}

# resource "helm_release" "nginx" {
#   depends_on = [kubernetes_namespace.nginx]
#   namespace = kubernetes_namespace.nginx.metadata[0].name
#   name       = "nginx-ingress-controller"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "nginx-ingress-controller"
#   timeout    = 300

#   set {
#     name  = "controller.service.type"
#     value = "LoadBalancer"
#   }  
#   set {
#     name  = "controller.service.loadBalancerIP"
#     value = azurerm_public_ip.ngxip.ip_address
#   }
resource "helm_release" "nginx" {
  depends_on = [kubernetes_namespace.nginx]
  namespace = kubernetes_namespace.nginx.metadata[0].name
  name       = "nginx-ingress-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  timeout    = 300

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }  
  set {
    name  = "controller.service.loadBalancerIP"
    value = azurerm_public_ip.ngxip.ip_address
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }
}



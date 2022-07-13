#https://github.com/Azure-Terraform/terraform-azurerm-kubernetes-nginx-ingress

resource "azurerm_resource_group" "nginx-rg" {
  name     = var.ngxrg
  location = var.loc
}

resource "azurerm_role_assignment" "ngx-ra01" {
  scope                = azurerm_resource_group.nginx-rg.id
  role_definition_name = "Network Contributor"
  principal_id         = var.aksngx-spnid
  
}
resource "azurerm_public_ip" "ngxip" {
  name                = var.ngxip
  resource_group_name = "mc_aks-rg_${var.aks-name}_${var.loc}"
  location            = var.loc
  allocation_method   = "Static"
  sku = "Standard"
  sku_tier = "Regional"
  availability_zone = "Zone-Redundant"
}


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
}

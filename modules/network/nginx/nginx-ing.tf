

resource "azurerm_resource_group" "nginx-rg" {
  name     = var.ngxrg
  location = var.loc
}

resource "azurerm_role_assignment" "ngx-ra01" {
  scope                = azurerm_resource_group.nginx-rg.id
  role_definition_name = "Network Contributor"
  principal_id         = var.aks-spnid
  
}
resource "azurerm_public_ip" "ngxip" {
  name                = var.ngxip
  resource_group_name = azurerm_resource_group.nginx-rg.name
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

resource "helm_release" "nginx" {
  depends_on = [kubernetes_namespace.nginx]
  namespace = kubernetes_namespace.nginx.metadata[0].name
  name       = "nginx"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  timeout    = 300

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }  
  set {
    name  = "service.spec.loadBalancerIP"
    value = azurerm_public_ip.ngxip.ip_address
  }

  
}

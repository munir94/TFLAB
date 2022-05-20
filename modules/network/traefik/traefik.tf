

resource "azurerm_resource_group" "traefik-rg" {
  name     = var.tfkrg
  location = var.loc
}

resource "azurerm_role_assignment" "tfk-ra01" {
  scope                = azurerm_resource_group.traefik-rg.id
  role_definition_name = "Network Contributor"
  principal_id         = var.aks-spnid
  
}
resource "azurerm_public_ip" "tfkip" {
  name                = var.tfkip
  resource_group_name = azurerm_resource_group.traefik-rg.name
  location            = var.loc
  allocation_method   = "Static"
  sku = "Standard"
  sku_tier = "Regional"
  availability_zone = "Zone-Redundant"
}


resource "kubernetes_namespace" "traefik" {
    metadata {
        name = "traefik"
    }
}
resource "null_resource" "helm-update" {
  provisioner "local-exec" {
    command = "helm repo update"
  }
}

resource "helm_release" "traefik" {
  depends_on = [kubernetes_namespace.traefik]
  namespace = kubernetes_namespace.traefik.metadata[0].name
  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  timeout    = 300

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }  
  set {
    name  = "service.spec.loadBalancerIP"
    value = azurerm_public_ip.tfkip.ip_address
  }
  set {
    name = "service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group"
    value = azurerm_resource_group.traefik-rg.name
    type  = "string"
  }
#https://stackoverflow.com/questions/69269097/unable-to-pass-service-annotations-when-deploying-helm-chart-via-terraform
#https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release
  # Set Traefik as the Default Ingress Controller
    set {
        name  = "ingressClass.enabled"
        value = "true"
    }
    set {
        name  = "ingressClass.isDefaultClass"
        value = "true"
    }

    set {
    name  = "logs.access.enabled"
    value = "true"
  }

    set {
    name  = "ports.traefik.expose"
    value = "true"
  }
    
    # Default Redirect
    # set {
    #     name  = "ports.web.redirectTo"
    #     value = "websecure"
    # }

    # # Enable TLS on Websecure
    # set {
    #     name  = "ports.websecure.tls.enabled"
    #     value = "true"
    # }
}
# Add the Traefik Repo
#helm repo add traefik https://helm.traefik.io/traefik
# Update Helm
#helm repo update
# Install Traefik to your cluster
#helm install traefik traefik/traefik
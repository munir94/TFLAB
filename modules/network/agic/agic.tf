

# resource "azurerm_resource_group" "ag-rg" {
#   name     = var.agrg
#   location = var.loc
# }


resource "azurerm_user_assigned_identity" "ag_uid" {
  resource_group_name = var.agrg
  location            = var.loc
  name = "identity1"
}
resource "azurerm_public_ip" "agip" {
  name                = var.agip
  resource_group_name = var.agrg
  location            = var.loc
  allocation_method   = "Static"
  sku = "Standard"
  sku_tier = "Regional"
  availability_zone = "Zone-Redundant"
}

locals {
  test_backend_address_pool_name = "dummy"
  test_fqdn = "dummy"
}

resource "azurerm_application_gateway" "agw" {
  name                = "${var.agname}-Ingress"
   resource_group_name = var.agrg
  location            = var.loc

  sku {
    name = var.ag_sku
    tier = var.ag_tier
  }

  autoscale_configuration {
    min_capacity = var.ag_min
    max_capacity = var.ag_max
  }
  
  ## SSL CERT 
  
  # ssl_certificate {
  #   name     = var.certificate_name
  #   data     = filebase64(var.certificate_path)
  #   password = var.certificate_pwd
  # }

  gateway_ip_configuration {
    name      = var.agsnetname
    subnet_id = var.agsnetid
  }

  frontend_port {
    name = "${var.agname}-feport"
    port = 80
  }

  frontend_port {
    name = "https_port"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "${azurerm_public_ip.agip.name}-feip"
    public_ip_address_id = azurerm_public_ip.agip.id
  }

  # backend_address_pool {
  #   name = "${var.agname}-beap"
  #   fqdns = [var.test_fqdn]
  #   #fqdns = ["${local.test_fqdn}"]
    
  # }


  backend_address_pool {
   name = "${var.agname}-beap"
   fqdns = [
        "cafdemo.appserviceenvironment.net"
      ]
}

  backend_http_settings {
    name                  = "${var.agname}-be-htst"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "${var.agname}-httplstn"
    frontend_ip_configuration_name = "${azurerm_public_ip.agip.name}-feip"
    frontend_port_name             = "${var.agname}-feport"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${var.agname}-rqrt"
    rule_type                  = "Basic"
    http_listener_name         = "${var.agname}-httplstn"
    backend_address_pool_name  = "${var.agname}-beap"
    backend_http_settings_name = "${var.agname}-be-htst"
  
  }
 
}

#user identity with SPN 

#create 

# resource "azurerm_user_assigned_identity" "identity" {
#   resource_group_name = azurerm_kubernetes_cluster.k8s.node_resource_group
#   location            = azurerm_resource_group.rg.location
#   name                = var.identity_name
# }


#assign spn as contributor to aks subnet 
resource "azurerm_role_assignment" "ra1" {
  scope                = var.akssnet_id
  role_definition_name = "Contributor"
  principal_id         = var.spn_id

}

#assign spn as reader to appgw rg
resource "azurerm_role_assignment" "ra2" {
  scope                = var.agrg_id
  role_definition_name = "Reader"
  principal_id         = var.spn_id

}

#assign spn as contributor to appgw 
resource "azurerm_role_assignment" "ra3" {
  scope                = azurerm_application_gateway.agw.id
  role_definition_name = "Contributor"
  principal_id         = var.spn_id

}
resource "azurerm_role_assignment" "ra4" {
  scope                = azurerm_user_assigned_identity.ag_uid.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.spn_id
  
}

# resource "azurerm_role_assignment" "agw" {
#   scope                = var.subid
#   role_definition_name = "Contributor"
#   principal_id         = var.spn_id
# }



#helm for aks app gw 

provider "helm" {
  #version        = "2.3.0"
  #install_tiller = true
   kubernetes { 
    #load_config_file      = "false"
    host                   =  var.host
    client_certificate     =  var.client_certificate
    client_key             =  var.client_key
    cluster_ca_certificate =  var.cluster_ca_certificate
   }
   }

# data "helm_repository" "helm_appgw" {
#   name = "application-gateway-kubernetes-ingress"
#   url  = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
# }


resource "helm_release" "aad-pod-identity" {
   name       = "aad-pod-identity"
   repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
   chart      = "aad-pod-identity"
   timeout    = 120

   set {
   name  = "rbac.enabled"
   value = "true"
   }
}
resource "helm_release" "agw_ingress" {
  name       = "ag"
  repository = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
  chart      = "ingress-azure"
  version    = "1.2.1"
 
set {
  name  = "appgw.name"
  value = azurerm_application_gateway.agw.name
  }

  set {
  name  = "appgw.resourceGroup"
  value = var.agrg
  }

  set {
  name  = "appgw.subscriptionId"
  value = var.subid
  }

  set {
  name  = "appgw.usePrivateIP"
  value = false
  }

  set {
  name  = "appgw.shared"
  value = false
  }

  set {
  name  = "armAuth.type"
  value = "aadPodIdentity"
  }

  set {
  name  = "rbac.enabled"
  value = true
  }

  set {
  name  = "armAuth.identityResourceID"
  value = var.spn_id
  }

  set {
  name  = "armAuth.identityClientID"
  value = var.client_id
  }
}

/*
  values = [
    <<EOF
verbosityLevel: 3
appgw:
    subscriptionId: ${var.subid}
    resourceGroup: ${var.agrg}
    name: ${azurerm_application_gateway.agw.name}
    shared: false
armAuth:
    type: aadPodIdentity
    identityResourceID: ${var.spn_id}
    identityClientID:  ${var.client_id}
rbac:
    enabled: false 
aksClusterConfiguration:
    apiServerAddress: ${var.host}
EOF 
, 
  ]
}
*/
#resourceGroup: ${azurerm_resource_group.ag-rg.id}
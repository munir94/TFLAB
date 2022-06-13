

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



resource "azurerm_application_gateway" "agw" {
  name                = "${var.agname}-Ingress"
   resource_group_name = var.agrg
  location            = var.loc
timeouts {
  update = "5m"
  create = "5m"
}
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

  backend_address_pool {
   name = "${var.agname}-beap"
   fqdns = [
        "dummy"
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
  lifecycle {
  ignore_changes = [
    backend_address_pool,
    backend_http_settings,
    frontend_port,
    http_listener,
    probe,
    redirect_configuration,
    request_routing_rule,
    ssl_certificate,
    tags,
    url_path_map,
  ]
}
 
}

#ROLE ASSIGNMENT 
 

 ### IMPORTANT NOTICE ###
 # Give AGIC's identity Contributor access to you App Gateway.
 # Give AGIC's identity Reader access to the App Gateway resource group

# resource "azurerm_role_assignment" "ra1" {
#   scope                = data.azurerm_subnet.kubesubnet.id
#   role_definition_name = "Network Contributor"
#   principal_id         = var.aks_service_principal_object_id

#   depends_on = [azurerm_virtual_network.test]
# }

resource "azurerm_role_assignment" "ra1" {
  scope                = var.akssnet_id
  role_definition_name = "Network Contributor"
  principal_id         = var.spn_id

  #depends_on = [azurerm_virtual_network.test]
}

resource "azurerm_role_assignment" "ra2" {
  scope                = azurerm_user_assigned_identity.ag_uid.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.spn_id
  depends_on           = [azurerm_user_assigned_identity.ag_uid]
}

# resource "azurerm_role_assignment" "ra3" {
#   scope                = azurerm_application_gateway.network.id
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_user_assigned_identity.ag_uid.principal_id
#   depends_on = [
#     azurerm_user_assigned_identity.testIdentity,
#     azurerm_application_gateway.network,
#   ]
# }

resource "azurerm_role_assignment" "ra3" {
  scope                = var.agnetid
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.ag_uid.principal_id
#   depends_on = [
#     azurerm_user_assigned_identity.testIdentity,
#     azurerm_application_gateway.network,
#   ]
}

resource "azurerm_role_assignment" "ra4" {
  scope                = var.aks-rg
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.ag_uid.principal_id
  
}


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



#overwrite existing kube config 
resource "null_resource" "main" {
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${var.agrg} --name ${var.aks-name} --overwrite-existing" # && kubectl apply -f deployment.yaml" # && kubectl create namespace wavy-whatsapp && kubectl create secret tls wavy-global --key wildcard_wavy_global.key --cert wildcard_wavy_global.crt -n wavy-whatsapp"
  }
}
   #backup

resource "helm_release" "aad-pod-identity" {
   name       = "aad-pod-identity"
   repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
   chart      = "aad-pod-identity"
   timeout    = 120
   

   set {
   name  = "rbac.enabled"
   value = "false"
   }
}
/*
resource "helm_release" "agw_ingress" {
  name       = "ingress"
  repository = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
  chart      = "ingress-azure"
  version    = "1.4.0"

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
    identityResourceID: ${azurerm_user_assigned_identity.ag_uid.id}
    identityClientID:  ${azurerm_user_assigned_identity.ag_uid.client_id}
rbac:
    enabled: false 
aksClusterConfiguration:
    apiServerAddress: ${var.host}
EOF 
, 
  ]
}
*/
 
resource "null_resource" "helm" {
  provisioner "local-exec" {
    command = "helm repo update"
  }
}

resource "helm_release" "agw_ingress" {
  name       = "ingress"
  repository = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
  chart      = "ingress-azure"
 # version = "1.4.0"
 
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

#   set {
#   name  = "armAuth.type"
#   value = "servicePrincipal"
#   }
#   set {
#   name  = "armAuth.secretJSON"
#   value = var.client_key
#   }

#1 change aad pod to SP
  set {
  name  = "armAuth.type"
  value = "aadPodIdentity"
  }

  set {
  name  = "rbac.enabled"
  value = false
  }
  set {
  name  = "armAuth.identityResourceID"
  value = azurerm_user_assigned_identity.ag_uid.id
  }
  set {
  name  = "armAuth.identityClientID"
  value = azurerm_user_assigned_identity.ag_uid.client_id
  }

  set {
    name = "reconcilePeriodSeconds"
    value = "30"
  }
}
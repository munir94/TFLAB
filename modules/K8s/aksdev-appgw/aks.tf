resource "azurerm_resource_group" "aks-rg" {
  name     = "aks-rg"
  location = "southeastasia"
}


resource "azurerm_role_assignment" "ra1" {
  scope                = var.appgwrg
  role_definition_name = "Reader"
  principal_id         = var.aks-spn

}
resource "azurerm_role_assignment" "ra2" {
  scope                = var.appgwid
  role_definition_name = "Contributor"
  principal_id         = var.aks-spn

}
resource "azurerm_kubernetes_cluster" "aks1" {
  name                = var.aks-name
  location            = azurerm_resource_group.aks-rg.location
  resource_group_name = azurerm_resource_group.aks-rg.name
  dns_prefix          = var.aks-dns
  kubernetes_version  = var.aks-version


  default_node_pool {
    name       = "default"
    enable_auto_scaling = true
    min_count = 1
    max_count = 3
    node_count = 1
    vm_size    = "Standard_D2_v3"
    type = "VirtualMachineScaleSets"
    os_disk_size_gb = 127
    max_pods = 80
    vnet_subnet_id = var.aks-subnet-id


  }
  service_principal {
    client_id = var.client_id
    client_secret = var.client_sec
  }

  linux_profile {
    admin_username = var.admin
    ssh_key {
      key_data = var.ssh
    }
  }
  windows_profile {
    admin_username = var.admin
    admin_password = var.winpass
  }
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "Standard"
      }
  
#  addon_profile {
#     # oms_agent {
#     #   enabled                    = var.addons.oms_agent
#     #   log_analytics_workspace_id = data.azurerm_log_analytics_workspace.workspace.id
#     # }
 
#     ingress_application_gateway {
#       enabled   = true
#       subnet_id = var.agsnetid 
#     }
 
#   }

 ingress_application_gateway {
 
 gateway_id = var.appgwid
 #gateway_name = var.appgwname
 #subnet_cidr = var.agsnetrange
 #subnet_id =  var.appgwnetid

 }
 

 #https://github.com/crayon/terraform-azurerm-aks/issues/8
  tags = {
    Environment = "DEV"
  }
     lifecycle {
  ignore_changes = [
   default_node_pool,
  ]
}
}

# resource "null_resource" "get-aks-cred" {
#   provisioner "local-exec" {
#     command = "az aks Get-Credentials -g ${lower(azurerm_resource_group.aks-rg.name)} -n ${lower(var.aks-name)}"
#     interpreter = ["PowerShell", "-Command"]
#   }
# }


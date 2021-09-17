resource "azurerm_resource_group" "aks-rg" {
  name     = "AKS-RG"
  location = "southeastasia"
}

resource "azurerm_kubernetes_cluster" "aks1" {
  name                = var.aks-name
  location            = azurerm_resource_group.aks-rg.location
  resource_group_name = azurerm_resource_group.aks-rg.name
  dns_prefix          = var.aks-dns
  kubernetes_version  = var.aks-version
  

  default_node_pool {
    name       = "default"
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
    admin_username = "muniradm"
    ssh_key {
      key_data = var.ssh
    }
  }
  #TODO Windows Profile
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "Standard"
      }
  
  tags = {
    Environment = "DEV"
  }
}


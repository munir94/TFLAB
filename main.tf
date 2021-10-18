terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.73.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=2.5.0"
    }

  }

}

# Configure the Microsoft Azure Provider
provider "azurerm" {

  subscription_id = "xx"

  features {}
}
module "vnet00" {
  source        = "./modules/network/vnet"
  vnet-name     = "vNet-00-aks"
  vnet-range    = ["192.168.16.0/24", "172.16.0.0/22"]
  subnets-name  = ["subnet01", "aks-subnet", "ApplicationGatewaySubnet"]
  subnets-range = ["192.168.16.0/28", "172.16.0.0/24", "192.168.16.128/26"]
  vnet-location = "southeastasia"

}
module "myaks" {
  source        = "./modules/k8s/dev"
  aks-name      = "aks01"
  aks-dns       = "aks01-dns"
  aks-version   = "1.21.2"
  aks-subnet-id = module.vnet00.vnet_subnets.1
 admin         = "muniradm"
  ssh           = ""
  winpass       = ""
  client_id     = ""
  client_sec    = ""
}

module "k8s" {
  source = "./modules/K8s/k8"
  #load_config_file       = "false"
  host                   = module.myaks.host
  client_certificate     = base64decode(module.myaks.client_certificate)
  client_key             = base64decode(module.myaks.client_key)
  cluster_ca_certificate = base64decode(module.myaks.cluster_ca_certificate)

}

# module "AppGW01" {
#   source     = "./modules/network/appgw"
#   agsnetname = module.vnet00.vnet_subnets-name.2
#   agsnetid   = module.vnet00.vnet_subnets.2

# }

#test

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.73.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {

  subscription_id = var.subid
  features {}
}
###test comment 
module "vnet01" {
  source         = "./modules/vnet"
  vnet-range     = ["192.168.16.0/24","172.16.0.0/22"]
  subnets-name   = ["subnet01","aks-subnet"]
  subnets-range  = ["192.168.16.0/28","172.16.0.0/24"]
  vnet-location  = "southeastasia"
}

module "myaks" {
  source         = "./modules/k8s"
  aks-name       = "aks01"
  aks-dns        = "aks01-dns"
  aks-version    = "1.20.9"
  aks-subnet-id  = module.vnet01.vnet_subnets.1
  
}
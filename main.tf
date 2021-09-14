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

  #subscription_id = var.subid
  subscription_id = ""
  features {}
}
###test comment 
module "vnet00" {
  source         = "./modules/vnet"
  vnet-name      = "vNet-00-hub"
  vnet-range     = ["192.168.16.0/24","172.16.0.0/22"]
  subnets-name   = ["subnet01","aks-subnet"]
  subnets-range  = ["192.168.16.0/28","172.16.0.0/24"]
  vnet-location  = "southeastasia"
}

module "vnet01" {
  source         = "./modules/vnet"
  vnet-name      = "vNet-01-prd"
  vnet-range     = ["192.168.17.0/24","172.17.0.0/22"]
  subnets-name   = ["subnet01","aks-subnet"]
  subnets-range  = ["192.168.17.0/28","172.17.0.0/24"]
  vnet-location  = "southeastasia"
}
#14092021
module "peer-vnet01-02" {
  source                  = "./modules/vnet-peering"
  peer-name               = "Peer1"
  peer-rg                 = module.vnet00.vnet-rg
  source-vnet-name        = module.vnet00.vnet-name
  target-vnet-id          = module.vnet01.vnet-id
  use-remote-gw           = "False"
 # vnet-creation  = module.vnet01
}

module "peer-vnet02-01" {
  source                   = "./modules/vnet-peering"
  peer-name                = "peer1"
  peer-rg                  = module.vnet01.vnet-rg
  source-vnet-name         = module.vnet01.vnet-name
  target-vnet-id           = module.vnet00.vnet-id
  use-remote-gw            = "false" 
  
}
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
  
  features {}
}
module "peer-vnet01-02" {
  source                  = "./modules/network/vnet-peering"
  peer-name               = module.vnet00.vnet-name - " Peer To " - module.vnet01.vnet-name
  peer-rg                 = module.vnet00.vnet-rg
  source-vnet-name        = module.vnet00.vnet-name
  target-vnet-id          = module.vnet01.vnet-id
  use-remote-gw           = "False"
 
}



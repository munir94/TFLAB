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
module "law-01" {
  source = "./modules/diagnostic/log-analytics"
}



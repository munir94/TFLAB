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
  subscription_id = "ee31172f-3e56-4f55-94e8-6adce8c23e83"
  features {}
}
module "law-01" {
  source = "./modules/diagnostic/log-analytics"
}



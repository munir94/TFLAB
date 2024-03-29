terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.99.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
 # ! subscription 
  subscription_id = var.subscription_id

  features {}
}


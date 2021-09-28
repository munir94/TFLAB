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

  subscription_id = "ee31172f-3e56-4f55-94e8-6adce8c23e83"
  
  features {}
}
module "vnet00" {
  source         = "./modules/network/vnet"
  vnet-name      = "vNet-00-aks"
  vnet-range     = ["192.168.16.0/24","172.16.0.0/22"]
  subnets-name   = ["subnet01","aks-subnet"]
  subnets-range  = ["192.168.16.0/28","172.16.0.0/24"]
  vnet-location  = "southeastasia"

}
module "myaks" {
   source         = "./modules/k8s/dev"
    aks-name       = "aks01"
   aks-dns        = "aks01-dns"
   aks-version    = "1.21.2"
   aks-subnet-id  = module.vnet00.vnet_subnets.1
   admin = "muniradm"
   ssh = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDlF9aHZv06i0oQlyR/+DegoGjW+tR7t0V0GT4xGYYEvoc9A0X+3GJEKPD3dom+pn9oXfnj0gy/IvyNnP3dGHfeWuE8Agu5HJETWuvwO7pTJnhHvXu08sOw/yZBPIEP7fjW3c+OAobvGbeWgOUVBenK9Qz6fcz6rhkvPETDFS7NUe4i7/6YWFk6CaTus7mQEKDtEmjKQ5OojyKEkTrlbbS1+ip+D33ymQi4vnUVQN/XCGF4iPeKzT8Sh6h1LPOIKATXN4f8FdiWyVgnYoEsuuFCfyqybWG1QXdCM1CrLIMV4e6Ji7Klava/4NEINx3uj2KH0r/eS4SdYN+Nc73JULR9f0VKwPKhb7olk0eONZBzarQwL7c7VsVe8Bsl5oAlncIhH1CqBrKrCT7HAdljH4ljb0fLh/Psc5I3wei3S8hKEQweB95dY+m7AHsjW78aZtvYA95yU+YrYOwwdKp93vYhwm8drzQvuUYvXMWDB2gOL+cXv3hq+O8WAEcfGx2FpmW/EKQdGoyhuNzD0u9t8uiALcYmR5PxXkPbKO1V0zakuG+MQ3yYJjvjvcS7CAxssXMxwkHaapyb6v5ELPXKnxVtPDsuREYfSESDIGQoJIPpwnjz7sbVipUb884yV94BuaKUYFzl3/w61ihCAHpMZBENFvA3pPJLVFld+tFmcG9q9w== rsa-key-20210901"
   winpass= "3nfr@5y5@12345" 
   client_id = "0dbb3170-8ab0-49f4-b64a-ec81a3723b8e"
   client_sec = "739-iosQjAF8h~OOr2Ni~-oSz~8.y~MV16"
}

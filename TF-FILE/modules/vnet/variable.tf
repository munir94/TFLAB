variable "subid" {
  default = ""
  sensitive = true 
}

variable "vnet-rg" {
  type = string 
  description = "RG for Vnet"
  default = "VNET-RG"
  
}
variable "vnet-name" {
  type = string 
  description = "name for Vnet"
  default = "VNET-TF"
  
}
variable "vnet-location" {
  type = string 
  description = "Region for Vnet"
  default = "southeastasia"
  
}

variable "vnet-range" {
  type = list(string)
  description = "Address range for Vnet"
  default = ["192.168.16.0/24"]
  
}
variable "vnet-dns" {
  type = list(string)
  description = "DNS for Vnet"
  default = ["168.63.129.16"]
  
}

variable "subnets-name" {
  type = list(string)
  description = "subnet name for Vnet"
  #default = ["Subnet01","168.63.129.16"]
  
}
variable "subnets-range" {
  type = list(string)
  description = "subnet range for Vnet"
  #default = ["Subnet01","168.63.129.16"]
}
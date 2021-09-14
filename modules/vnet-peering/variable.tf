
#TODO add description to all variable
variable "peer-name" {
  default = "vnet-peering"
   
}

variable "peer-rg" {
  default = ""
   
}
variable "vnet-id" {
  default   = ""
  sensitive = true  
}
variable "target-vnet-id" {
  default   = ""
  sensitive = true  
}

variable "use-remote-gw" {
  default   = ""
  sensitive = true  
}

variable "vnet-creation" {
  default   = ""
   
}

#TODO add description to all variable
variable "peer-name" {
  default = "vnet-peering"
   
}

variable "peer-rg" {
  default = ""
   
}
variable "source-vnet-name" {
  default   = ""
  sensitive = true  
}
variable "target-vnet-id" {
  type = string
  default   = "false"
  sensitive = true  
}

variable "use-remote-gw" {
  default   = ""
  sensitive = true  
}

# variable "vnet-creation" {
#   default   = ""
   
# }
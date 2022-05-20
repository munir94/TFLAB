variable "client_id" {
    default = ""
    description = "client id for SPN"
    sensitive = true
}
variable "client_sec" {
  default = ""
  description = "client secret for SPN"
  sensitive = true
}
variable "admin" {
    default = "muniradm"
    description = "Admin for Linux and Windows"
    sensitive = true
}
variable "ssh" {
    default = ""
    description = "SSH key"
    sensitive = true
}
variable "winpass" {
    default = "1a2bP@ssw0rd@1234567"
    description = "Admin for Windows"
    sensitive = true
}
variable "aks-subnet-id" {
  type = string 
  description = "subnet for aks deployment"
}
variable "aks-name" {
  type = string 
  description = "name for aks deployment"
  default = "myaks"
}
variable "aks-dns" {
  type = string 
  description = "dnsname for aks deployment"
  default = "myaks-dns"
}
variable "aks-version" {
  type = string 
  description = "version for aks deployment"
  default = "1.22.4"
}
variable "appgwid" {
  type = string 
  description = "App GW  ID "

}
variable "appgwrg" {
  type = string 
  description = "App GW  RG"

}
variable "aks-spn" {
  type = string
  description = "aks spn for access"
}
# variable "appgwname" {
#   type = string 
#   description = "App GW  name "

# }
# # variable "agsnetrange" {
# #   type = string 
# #   description = "App GW  ID "

# # }
# variable "appgwnetid" {
#   type = string 
#   description = "App GW  SUBNET ID "

# }
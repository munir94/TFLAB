variable "agrg" {
  default = "APPGW-RG"

}
variable "loc" {
  default = "southeastasia"

}
variable "agip" {
  default = "APPGW-PIP"
}

variable "agname" {
  default = "App-GW"
}

variable "ag_sku" {
  default = "Standard_v2"
}

variable "ag_tier" {
  default = "Standard_v2"
}

variable "test_fqdn" {
  type = string 
  default = "Dummy"
}
variable "ag_min" {
  default = 0
}
variable "ag_max" {
  default = 2
}
variable "agsnetname" {

}
variable "agsnetid" {

}
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
  default = "Standard_V2"
}

variable "ag_tier" {
  default = "Standard_V2"
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
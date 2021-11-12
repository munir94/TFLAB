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
variable "agnetid" {

}
variable "agsnetid" {

}

variable "client_id" {
    default = ""
    description = "client id for SPN"
    sensitive = true
}
variable "spn_id" {
    default = ""
    description = "spn id for SPN"
    sensitive = true
}

variable "subid" {
   
    sensitive = true
}

variable "akssnet_id" {
   
 description = "subnet id of AKS subnet"
}

variable "host" {
}

variable "client_certificate" {
}

variable "client_key" {
}

variable "cluster_ca_certificate" {
}

variable "aks-rg" {
}

variable "agrg_id" {
}


variable "client_key_base" {
}




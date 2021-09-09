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

variable "ssh" {
    default = ""
    description = "SSH key"
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
  description = "name for aks deployment"
  default = "1.20.9"
}
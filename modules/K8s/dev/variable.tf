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
  default = "1.24.0"
}
variable "aks-region" {
  type = string 
  description = "region for aks deployment"
  default = "southeastasia"
}
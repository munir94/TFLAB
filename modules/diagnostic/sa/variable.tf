variable "sa-rg" {
  type = string 
  description = "RG for Boot Diagnostic"
  default = "DIAG-RG"
}
variable "sa-loc" {
  type = string 
  description = "Location for Boot Diagnostic"
  default = "SoutheastAsia"
}
variable "saname" {
  type = string 
  description = "Name for Boot Diagnostic"
  default = "bootdiagstorage"
}
variable "sacontainer" {
  type = list(string) 
  description = "storage account container"
  
}
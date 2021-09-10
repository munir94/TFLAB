variable "saboot-rg" {
  type = string 
  description = "RG for Boot Diagnostic"
  default = "DIAG-RG"
}
variable "saboot-loc" {
  type = string 
  description = "Location for Boot Diagnostic"
  default = "SoutheastAsia"
}
variable "boot-sa" {
  type = string 
  description = "Name for Boot Diagnostic"
  default = "bootdiagstorage"
}
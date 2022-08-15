variable "aks-name"{
    type = string 
    
}
variable "sub-id"{
    type = string 
    
}
variable "spn-id"{
    type = string 
    
}
variable "client-id"{
    type = string 
    
}
variable "client-sec"{
    type = string 
    
}
variable "tenant-id"{
    type = string 
    
}
variable "host" {
    type = string
    default = "kubecost"
  
}
variable "url" {
    type = string
    default = "kubecost.munirtajudin.xyz"
  
}
variable "saname" {
    type = string
   
  
}
variable "sakey" {
    type = string
   
  
}
variable "sacontainer" {
    type = string
   
  
}
variable "sapath" {
    type = string
   
  
}
variable "azcloud" {
    type = string
   default = "public"
}





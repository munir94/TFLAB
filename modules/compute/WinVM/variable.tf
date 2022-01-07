
# resource "random_string""vmid"{
#     length = 4
#     special = false
#     number = true
#     lower = true 
# }

variable "vmrg" {
type = string 
default =  "VM-RG" 
}

variable "rgloc" {
type = string 
default =  "southeastasia" 
}

variable "vmname" {
type = string 
default =  "VM"
}

variable "subnet_id" {
    type = string
  
}
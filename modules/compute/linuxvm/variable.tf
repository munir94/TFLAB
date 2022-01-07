


# resource "random_string""vmid"{
#     length = 4
#     special = false
#     number = true
#     lower = true 
# }

variable "vmrg" {

}

variable "rgloc" {

}

variable "vmname" {
type = string 
default =  "VM" 
}





variable "subnet_id" {
    type = string
  
}
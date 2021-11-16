variable "host" {
}

variable "client_certificate" {
}

variable "client_key" {
}

variable "cluster_ca_certificate" {
}

variable "app" {
 default = "httpd"
}

variable "image" {
    type = string
    default = "httpd"
}

variable "app-port" {
    type = string
  default = "80"
}

variable "app-tgport" {
type = number
  default = 80
}
variable "replica" {
    type = number
    default = 1
}
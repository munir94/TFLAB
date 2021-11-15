resource "azurerm_network_security_group" "nsg1" {
  name                = var.nsg-name
  location            = var.nsg-loc
  resource_group_name = var.nsg-rg

  security_rule {
    name                       = "APPGW"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    #destination_port_range     = "65200-65535,8123,80,443"

    #destination_port_range = ["65200-65535", "8123"]   #doesnot work
    destination_port_ranges = ["65200-65535", "8123","80","443"]  #worked
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "example" {

  subnet_id                 = var.subnet-id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}
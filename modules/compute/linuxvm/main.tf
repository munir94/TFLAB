

resource "azurerm_network_interface" "linuxnic01" {
  name                = "${var.vmname}-nic"
  resource_group_name = var.vmrg
  location            = var.rgloc
  

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "linuxvm01" {
  name                = var.vmname
resource_group_name = var.vmrg
  location            = var.rgloc
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.linuxnic01.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("C:/OneDrive/key/key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
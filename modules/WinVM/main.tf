
resource "azurerm_windows_virtual_machine" "winvm" {
    count = length(var.winvm-name)
    name = var.winvm-name[count.index]
    
  
}

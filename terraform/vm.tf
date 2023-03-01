

# Crea una dirección IP pública vm
resource "azurerm_public_ip" "unirpublicip" {
  name                = "public-ip-vm"
  location            = azurerm_resource_group.unir.location
  resource_group_name = azurerm_resource_group.unir.name
  allocation_method   = "Static"
}



# apunta la ip publica a url
resource "azurerm_dns_a_record" "dns_a_record_vm" {
  name                = "vm.unir.io"
  zone_name           = azurerm_dns_zone.unirdnszone.name
  resource_group_name = azurerm_resource_group.unir.name
  ttl                 = 300

  records = [
    azurerm_public_ip.unirpublicip.ip_address
  ]
}


#data "dns_a_record_set" "dns" {
#  host = element(tolist("${azurerm_dns_zone.unirdnszone.name_servers}"), 0)
#}



# Crea una tarjeta de interfaz de red
resource "azurerm_network_interface" "vmnic" {
  name                = "unir-nic-vm"
  location            = azurerm_resource_group.unir.location
  resource_group_name = azurerm_resource_group.unir.name  
  dns_servers = ["8.8.8.8","8.8.4.4"]
  ip_configuration {
    name                          = "vmunic-ip-config"
    subnet_id                     = azurerm_subnet.unirsubnet.id
    public_ip_address_id          = azurerm_public_ip.unirpublicip.id
    private_ip_address_allocation = "Dynamic"
  }
}

#asocia nsg a interface de red
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.vmnic.id
  network_security_group_id = azurerm_network_security_group.ansg.id
}

# Crea una máquina virtual
resource "azurerm_linux_virtual_machine" "unirvm" {
  name                = "unir-vm"
  resource_group_name = azurerm_resource_group.unir.name
  location            = azurerm_resource_group.unir.location
  size                = "Standard_B1ls"
  admin_username      = "uniruser"
  computer_name       = "vm.unir.io"
  disable_password_authentication = true

  network_interface_ids = [azurerm_network_interface.vmnic.id]

  os_disk {
    name              = "unir-os-disk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"   
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "uniruser"
    public_key = file("${var.idRsaPath}")
  }

}




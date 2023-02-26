# Crea una red virtual
resource "azurerm_virtual_network" "unirvirtualnetwork" {
  name                = "unir-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.unir.location
  resource_group_name = azurerm_resource_group.unir.name
}


# Crea una subred
resource "azurerm_subnet" "unirsubnet" {
  name                 = "unir-subnet"
  resource_group_name  = azurerm_resource_group.unir.name
  virtual_network_name = azurerm_virtual_network.unirvirtualnetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}


# crea la zona dns
resource "azurerm_dns_zone" "unirdnszone" {
  name                = "unir.io"
  resource_group_name = azurerm_resource_group.unir.name
}




# crea security group para salida a internet
resource "azurerm_network_security_group" "ansg" {
  name                = "nsg"
  location            = azurerm_resource_group.unir.location
  resource_group_name =azurerm_resource_group.unir.name

  security_rule {
    name                       = "allow-internet-outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

 security_rule {
    name                       = "allow-https-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  
}


output "dns_servers" {
  value = azurerm_dns_zone.unirdnszone.name_servers
}
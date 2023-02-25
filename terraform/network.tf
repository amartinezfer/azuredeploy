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

output "dns_servers" {
  value = azurerm_dns_zone.unirdnszone.name_servers
}
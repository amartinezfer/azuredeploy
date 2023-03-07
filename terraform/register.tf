
# creacion del registry
resource "azurerm_container_registry" "uniracr" {
  name                  = "unircontainerregistry"
  resource_group_name   = azurerm_resource_group.unir.name
  location              = azurerm_resource_group.unir.location
  sku                   = "Basic"
  admin_enabled            = true
 
}



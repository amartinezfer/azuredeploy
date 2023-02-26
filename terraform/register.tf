

resource "azurerm_container_registry" "uniracr" {
  name                  = "unircontainerregistry"
  resource_group_name   = azurerm_resource_group.unir.name
  location              = azurerm_resource_group.unir.location
  sku                   = "Basic"
  admin_enabled            = true
 
}

 output "acr_admin_user" {
    value = azurerm_container_registry.uniracr.admin_username
  }

 output "acr_admin_password" {
    value = azurerm_container_registry.uniracr.admin_password
    sensitive = true
  }



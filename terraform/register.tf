

resource "azurerm_container_registry" "uniracr" {
  name                  = "unircontainerregistry"
  resource_group_name   = azurerm_resource_group.unir.name
  location              = azurerm_resource_group.unir.location
  sku                   = "Basic"
  admin_enabled            = false
}

resource "azurerm_container_registry_webhook" "uniracrhook" {
  name                = "unircontainerregistry"
  resource_group_name = azurerm_resource_group.unir.name
  location            = azurerm_resource_group.unir.location
  registry_name       = azurerm_container_registry.uniracr.name
  actions              = ["push"]
  service_uri = "https://amafernandez/unir"
  status = "enabled"
  custom_headers      = {
    Authorization = "Basic YW1hZmVybmFkZXo6M3hsZWdhY3k="
  }
}

#resource "azurerm_role_assignment" "acr" {
#  scope                = azurerm_container_registry.uniracr.id
#  role_definition_name = "Contributor"
#  principal_id         = azuread_application.unirapp.application_id
#}


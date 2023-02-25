data "azuread_client_config" "current" {}

resource "azuread_application" "unirapp" {
  display_name = "unirapp"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "unirprincipal" {
  application_id               = azuread_application.unirapp.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}



resource "azurerm_role_assignment" "aks_cluster" {
  scope                = azurerm_kubernetes_cluster.unirkube.id
  role_definition_name = "Contributor"
  principal_id         =azuread_application.unirapp.application_id
}

resource "azurerm_role_assignment" "acr" {
  scope                = azurerm_container_registry.uniracr.id
  role_definition_name = "Contributor"
  principal_id         = azuread_application.unirapp.application_id
}


resource "azuread_service_principal_password" "unirprincipalpass" {
  service_principal_id = azuread_service_principal.unirprincipal.object_id
}

 output "unir_principal_id" {
    value     = "${azuread_service_principal.unirprincipal.application_id}"
    sensitive = false
 }

output "unir_principal_pass" {
    value     = "${azuread_service_principal_password.unirprincipalpass.value}"
    sensitive = true
 }
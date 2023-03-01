# Retrieve domain information
data "azuread_domains" "unir" {
  only_initial = true
}

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



# Create a user
#resource "azuread_user" "user" {
#  user_principal_name = "amafernandez@${data.azuread_domains.unir.domains.0.domain_name}"
#  display_name        = "Example User"
#  password            = var.password
#}

resource "azuread_service_principal_password" "unirprincipalpass" {
  service_principal_id = azuread_service_principal.unirprincipal.object_id
}



#dependencias
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.43.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.35.0"
    }
    dns = {
      source  = "hashicorp/dns"
      version = "=3.2.4"
    }
    local = {
      source  = "hashicorp/local"
      version = "=2.3.0"
    }
  }
}

provider "azurerm" {
   features {}
}

#resource group
resource "azurerm_resource_group" "unir" {
  name     = var.grupo_recursos
  location = var.location 
}

data "azurerm_client_config" "current" {}
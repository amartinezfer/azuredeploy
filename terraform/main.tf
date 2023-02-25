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
  }
}

provider "azurerm" {
   features {}
}

resource "azurerm_resource_group" "unir" {
  name     = var.grupo_recursos
  location = var.location 
}

data "azurerm_client_config" "current" {}
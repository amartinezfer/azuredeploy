

variable "grupo_recursos" {
  type        = string
  description = "grupo de recursos para todos los elementos creados"
  default     = "unirgroup"
}

variable "location" {
  type        = string
  description = "localizacion de los recursos"
  default     = "westeurope"
}

variable "service_principal_app_id" {
  default = ""
}

variable "service_principal_client_secret" {
  default = ""
}


# variables de salida
 output "unir_principal_id" {
    value     = "${azuread_service_principal.unirprincipal.application_id}"
    sensitive = false
 }

output "unir_principal_pass" {
    value     = "${azuread_service_principal_password.unirprincipalpass.value}"
    sensitive = true
 }

 
  output "aks_cluster_id" {
    value = azurerm_kubernetes_cluster.unirkube.id
  }

 output "client_certificate" {
    value     = azurerm_kubernetes_cluster.unirkube.kube_config.0.client_certificate
    sensitive = true
  }

  output "kube_config" {
    value = azurerm_kubernetes_cluster.unirkube.kube_config_raw
    sensitive = true
  }



  output "vm_public_ip" {
   value = azurerm_public_ip.unirpublicip.ip_address
  }

 output "mongo_public_ip" {
   value = azurerm_public_ip.mongo.ip_address
  }


  output "dns_servers" {
   value = azurerm_dns_zone.unirdnszone.name_servers
  }
  

   output "acr_admin_user" {
    value = azurerm_container_registry.uniracr.admin_username
  }

  output "acr_admin_password" {
    value = azurerm_container_registry.uniracr.admin_password
    sensitive = true
  }


    output "acr_server" {
    value = azurerm_container_registry.uniracr.login_server
    sensitive = true
  }


   
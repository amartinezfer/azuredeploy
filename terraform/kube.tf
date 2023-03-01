
# Crea una dirección IP pública kube
resource "azurerm_public_ip" "kubeunirpublicip" {
  name                = "public-ip-kube"
  location            = azurerm_resource_group.unir.location
  resource_group_name = azurerm_resource_group.unir.name
  allocation_method   = "Static"
  sku = "Standard"
}



# apunta la ip publica a url
resource "azurerm_dns_a_record" "dns_a_record_kube" {
  name                = "kube.unir.io"
  zone_name           = azurerm_dns_zone.unirdnszone.name
  resource_group_name = azurerm_resource_group.unir.name
  ttl                 = 300

  records = [
    azurerm_public_ip.kubeunirpublicip.ip_address
  ]
}




resource "azurerm_kubernetes_cluster" "unirkube" {
  name                = "unir-kubernetes-cluster"
  location            = azurerm_resource_group.unir.location
  resource_group_name = azurerm_resource_group.unir.name
  dns_prefix          = "unirdnscluster"

  linux_profile {
    admin_username = var.adminUser
    ssh_key {
      key_data = file("${var.idRsaPath}")
    }
  }
  
   service_principal {
    client_id     = "${azuread_service_principal.unirprincipal.application_id}"
    client_secret = "${azuread_service_principal_password.unirprincipalpass.value}"
  }

  depends_on = [
    azurerm_container_registry.uniracr
  ]
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"

    load_balancer_profile {
      outbound_ip_address_ids = [azurerm_public_ip.kubeunirpublicip.id]
    }
  }

}

#resource "azurerm_role_assignment" "aks_cluster" {
#  scope                = azurerm_kubernetes_cluster.unirkube.id
#  role_definition_name = "Contributor"
#  principal_id         =azuread_application.unirapp.application_id
#  depends_on = [
#    azurerm_kubernetes_cluster.unirkube
#  ]
#}




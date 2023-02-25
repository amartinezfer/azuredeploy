
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
    admin_username = "uniruser"
    ssh_key {
      key_data = file("~/azure/azuredeploy/terraform/certificates/id_rsa.pub")
    }
  }
  
   service_principal {
    client_id     = "${azuread_service_principal.unirprincipal.application_id}"
    client_secret = "${azuread_service_principal_password.unirprincipalpass.value}"
  }

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


  output "kube_public_ip" {
   value = azurerm_public_ip.kubeunirpublicip.ip_address
  }

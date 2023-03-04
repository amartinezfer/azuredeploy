
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

    #load_balancer_profile {
    #  outbound_ip_address_ids = [azurerm_public_ip.kubeunirpublicip.id]
    #}
  }

}


resource "local_file" "kubeconfig" {
  filename = "../ansible/kube.config"
  content  = azurerm_kubernetes_cluster.unirkube.kube_config_raw
}


resource "azurerm_public_ip" "mongo" {
  name                = "mongoip"
  location            = azurerm_resource_group.unir.location
  resource_group_name = azurerm_resource_group.unir.name

  allocation_method = "Static"
  sku               = "Standard"
}
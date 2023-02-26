

 locals {
    inventory_config = templatefile("${path.module}/templates/ansible_inventory.tftpl", {
      vm = azurerm_public_ip.unirpublicip.ip_address,
      kube = azurerm_public_ip.kubeunirpublicip.ip_address
      idrsa = "${var.idRsaPathPrivate}"
      user = "${var.adminUser}"
    })
}

resource "local_file" "inventory" {
    content  = local.inventory_config
    filename = "${path.module}/../ansible/inventory.ini"
}
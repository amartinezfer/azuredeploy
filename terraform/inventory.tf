
data "azurerm_subscription" "current" {}

 locals {
    inventory_config = templatefile("${path.module}/templates/ansible_inventory.tftpl", {
      vm = azurerm_public_ip.unirpublicip.ip_address,
      idrsa = "${var.idRsaPathPrivate}"
      user = "${var.adminUser}"
      register = azurerm_container_registry.uniracr.login_server
      register_user = azurerm_container_registry.uniracr.admin_username
      register_pass = azurerm_container_registry.uniracr.admin_password
      rsg = azurerm_resource_group.unir.name
      sub = data.azurerm_subscription.current.subscription_id
      ipmongo = azurerm_public_ip.mongo.ip_address
    })
}

resource "local_file" "inventory" {
    content  = local.inventory_config
    filename = "${path.module}/../ansible/inventory.ini"
}
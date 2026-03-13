output "vnet_id" {
  value = azurerm_virtual_network.test_vnet.id
}

output "app1_hostname" {
  value = azurerm_linux_web_app.app1.default_hostname
}

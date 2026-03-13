output "vnet_id" {
  value = azurerm_virtual_network.hub_vnet.id
}

output "agw_public_ip" {
  value = azurerm_public_ip.agw_pip.ip_address
}

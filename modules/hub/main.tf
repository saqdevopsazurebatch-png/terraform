resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "hub_vnet" {
  name                = "hub-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.hub_vnet_prefix]
}

resource "azurerm_subnet" "agw_subnet" {
  name                 = "agw-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = "hub-vnet"
  address_prefixes     = ["10.0.77.0/26"]
}

resource "azurerm_public_ip" "agw_pip" {
  name                = "${var.application_gateway_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "agw" {
  name                = var.application_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 2
  }

  gateway_ip_configuration {
    name      = "gw-ip"
    subnet_id = azurerm_subnet.agw_subnet.id
  }

  frontend_port {
    name = "port80"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "fe-ip"
    public_ip_address_id = azurerm_public_ip.agw_pip.id
  }

  backend_address_pool {
    name = "backend-pool"
  }

  backend_http_settings {
    name                  = "backend-http"
    port                  = 80
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
  }

  http_listener {
    name                           = "listener"
    frontend_ip_configuration_name = "fe-ip"
    frontend_port_name             = "port80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "backend-http"
  }
}

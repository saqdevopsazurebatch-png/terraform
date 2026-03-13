###############################################
# Convert SKU object → string (B1, S1, etc.)
###############################################
locals {
  service_plan_sku = "${var.app_service_plan_sku.tier}${var.app_service_plan_sku.size}"
}

###############################################
# VNet + Subnets
###############################################
resource "azurerm_virtual_network" "test_vnet" {
  name                = "test-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.test_vnet_prefix]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = var.resource_group_name
  virtual_network_name = "test-vnet"
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = var.resource_group_name
  virtual_network_name = "test-vnet"
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_subnet" "subnet3" {
  name                 = "subnet3"
  resource_group_name  = var.resource_group_name
  virtual_network_name = "test-vnet"
  address_prefixes     = ["10.1.3.0/24"]
}

###############################################
# NSGs
###############################################

resource "azurerm_network_security_group" "nsg_web" {
  name                = "nsg-web"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-80-443"
    direction                  = "Inbound"
    priority                   = 100
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_ranges    = ["80", "443"]
  }
}

resource "azurerm_network_security_group" "nsg_sql" {
  name                = "nsg-sql"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-1433"
    direction                  = "Inbound"
    priority                   = 100
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "1433"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet1_assoc" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg_web.id
}

resource "azurerm_subnet_network_security_group_association" "subnet2_assoc" {
  subnet_id                 = azurerm_subnet.subnet2.id
  network_security_group_id = azurerm_network_security_group.nsg_web.id
}

resource "azurerm_subnet_network_security_group_association" "subnet3_assoc" {
  subnet_id                 = azurerm_subnet.subnet3.id
  network_security_group_id = azurerm_network_security_group.nsg_sql.id
}

###############################################
# FIXED SERVICE PLAN (sku_name takes string)
###############################################
resource "azurerm_service_plan" "asp" {
  name                = "asp-test"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"

  # FINAL FIX — uses string from locals
  sku_name = local.service_plan_sku
}

###############################################
# Web App Names
###############################################
resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

###############################################
# Linux Web Apps
###############################################
resource "azurerm_linux_web_app" "app1" {
  name                = "app1-${random_integer.suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = true
    application_stack {
      python_version = "3.11"
    }
  }
}

resource "azurerm_linux_web_app" "app2" {
  name                = "app2-${random_integer.suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = true
    application_stack {
      python_version = "3.11"
    }
  }
}

resource "azurerm_linux_web_app" "app3" {
  name                = "app3-${random_integer.suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = true
    application_stack {
      python_version = "3.11"
    }
  }
}

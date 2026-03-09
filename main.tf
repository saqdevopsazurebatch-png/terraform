provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "jenkins-demo-rg"
  location = "East US"
}

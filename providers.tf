terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id =  "e6b31aba-0d89-4e4b-8834-8ade7e1e4511"
}

data "azurerm_subscription" "current" {}

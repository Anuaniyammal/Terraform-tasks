terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id       = "00000000-0000-0000-0000-000000000000"
  client_secret   = "20000000-0000-0000-0000-000000000000"
  tenant_id       = "10000000-0000-0000-0000-000000000000"
  subscription_id = "20000000-0000-0000-0000-000000000000"
}

resource "azurerm_resource_group" "rg1" {
  name     = "RGTerraform"
  location = "East US"

  lifecycle { # lifecycle
    prevent_destroy = true
  }
}

resource "azurerm_virtual_network" "VNET" {
  name                = "VNET1"
  location            = azurerm_resource_group.rg1.location # describes implicit dependencies as it uses resource group and block code name rg1 and location argument
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = ["10.0.0.0/16"]

  lifecycle { # lifecycle
    create_before_destroy = true
    ignore_changes        = [address_space]
  }
}

resource "azurerm_subnet" "subnet" {
  count                = 2  # creates 2 subnets
  name                 = "my-subnet-${count.index}"
  resource_group_name  = azurerm_resource_group.rg1.name# describes implicit dependencies
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = ["10.0.${count.index}.0/24"]


  lifecycle {
    create_before_destroy = true # lifecycle
  }
}

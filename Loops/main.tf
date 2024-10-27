terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.47.0"
    }
  }
}

# Define local variables
locals {
  # Create a map for resource details, for example.
  resource_map = { for k, v in var.resourcedetails : 
    k => {
      rg_name    = v.rg_name
      location   = v.location
      vnet_name  = v.vnet_name
      subnet_name = v.subnet_name
    }
  }

  # Additional locals can go here if you need them
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  client_id       = "00000000-0000-0000-0000-000000000000"
  client_secret   = "20000000-0000-0000-0000-000000000000"
  tenant_id       = "10000000-0000-0000-0000-000000000000"
  subscription_id = "20000000-0000-0000-0000-000000000000"
}

# Resource group using count
resource "azurerm_resource_group" "myrg" {
  count    = length(local.resource_map)
  name     = local.resource_map[count.index].rg_name
  location = local.resource_map[count.index].location
}

# Virtual network using count and referencing resource group by index
resource "azurerm_virtual_network" "myvnet" {
  count               = length(local.resource_map)
  name                = local.resource_map[count.index].vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg[count.index].location
  resource_group_name = azurerm_resource_group.myrg[count.index].name
}

# Subnet using count and referencing virtual network by index
resource "azurerm_subnet" "mysubnet" {
  count                = length(local.resource_map)
  name                 = local.resource_map[count.index].subnet_name
  address_prefixes     = ["10.0.0.0/24"]
  virtual_network_name = azurerm_virtual_network.myvnet[count.index].name
  resource_group_name  = azurerm_resource_group.myrg[count.index].name
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.8.0"
    }
  }
}

# Configure the Azure provider
provider "azurerm" {
    features {} 
 client_id       = "00000"
 client_secret   = "00000"
 tenant_id       = "00000"
 subscription_id = "00000"
}

# Define resource group
resource "azurerm_resource_group" "example_rg" {
  name     = "example-rg"
  location = "East US"
}

# Create a Public Virtual Network
resource "azurerm_virtual_network" "public_vnet" {
  name                = "public-vnet"
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name
  address_space       = ["10.1.0.0/16"]
}

# Create a Private Virtual Network
resource "azurerm_virtual_network" "private_vnet" {
  name                = "private-vnet"
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name
  address_space       = ["10.2.0.0/16"]
}

# Set up Network Peering from Public VNet to Private VNet
resource "azurerm_virtual_network_peering" "public_to_private" {
  name                      = "public-to-private-peering"
  resource_group_name       = azurerm_resource_group.example_rg.name
  virtual_network_name      = azurerm_virtual_network.public_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.private_vnet.id
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true
}

# Set up Network Peering from Private VNet to Public VNet
resource "azurerm_virtual_network_peering" "private_to_public" {
  name                      = "private-to-public-peering"
  resource_group_name       = azurerm_resource_group.example_rg.name
  virtual_network_name      = azurerm_virtual_network.private_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.public_vnet.id
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true
}

# Create a Private DNS Zone
resource "azurerm_private_dns_zone" "example_private_dns_zone" {
  name                = "example.com"
  resource_group_name = azurerm_resource_group.example_rg.name
}

# Link Public VNet to Private DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "public_vnet_link" {
  name                  = "public-vnet-link"
  resource_group_name   = azurerm_resource_group.example_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.example_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.public_vnet.id
  registration_enabled  = false
}

# Link Private VNet to Private DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "private_vnet_link" {
  name                  = "private-vnet-link"
  resource_group_name   = azurerm_resource_group.example_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.example_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.private_vnet.id
  registration_enabled  = true
}

# Add a Private DNS A Record for a Service
resource "azurerm_private_dns_a_record" "service_private_ip" {
  name                = "myservice"
  zone_name           = azurerm_private_dns_zone.example_private_dns_zone.name
  resource_group_name = azurerm_resource_group.example_rg.name
  ttl                 = 300
  records             = ["10.2.0.5"]
}

# Output the Private DNS Zone Name
output "private_dns_zone_name" {
  value = azurerm_private_dns_zone.example_private_dns_zone.name
}

# Output the Public VNet Address Space
output "public_vnet_address_space" {
  value = azurerm_virtual_network.public_vnet.address_space
}

# Output the Private VNet Address Space
output "private_vnet_address_space" {
  value = azurerm_virtual_network.private_vnet.address_space
}

# Output the DNS A Record (Private IP)
output "private_dns_a_record_ip" {
  value = azurerm_private_dns_a_record.service_private_ip.records
}

# Output Peering IDs to confirm their creation
output "public_to_private_peering_id" {
  value = azurerm_virtual_network_peering.public_to_private.id
}

output "private_to_public_peering_id" {
  value = azurerm_virtual_network_peering.private_to_public.id
}



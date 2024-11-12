terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.8.0"
    }
  }
}

provider "azurerm" {
    features {} 
 client_id       = ""
 client_secret   = ""
 tenant_id       = ""
 subscription_id = ""
}

resource "azurerm_resource_group" "example" {
  name     = "anurg-cosmosdb"
  location = "Central US"
}


resource "azurerm_cosmosdb_account" "example" {
  name                = "anucosmosdb-account"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.example.location
    failover_priority = 0
  }

  # Enable free tier and public access
  #enable_free_tier              = true (automatically apply the free tier to the first Cosmos DB account )
  public_network_access_enabled = true
}



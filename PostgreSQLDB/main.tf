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

# Create a Resource Group
resource "azurerm_resource_group" "example" {
  name     = "anu_rg"
  location = "Central US"
}

# Create PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "example" {
  name                   = "unique-postgresql-server123"
  resource_group_name    = azurerm_resource_group.example.name
  location               = azurerm_resource_group.example.location
  administrator_login    = "citus"               # Admin username
  administrator_password = "P@ssw0rd123!"          # Admin password 
  version                = "13"                    # PostgreSQL version
  sku_name               = "GP_Standard_D2s_v3"         # Choose an appropriate SKU
  storage_mb             = 32768                   # Storage size lowest in MB is (32GB)

  # Network configuration (public access enabled)
  public_network_access_enabled = true

  # Backup configuration
  backup_retention_days = 7                        # Backup retention period (in days)

  # Tags (optional)
  tags = {
    Environment = "Development"
  }
}

# Create PostgreSQL Database within Flexible Server
resource "azurerm_postgresql_flexible_server_database" "example_db" {
  name       = "postgresqldatabase"
  server_id  = azurerm_postgresql_flexible_server.example.id

}


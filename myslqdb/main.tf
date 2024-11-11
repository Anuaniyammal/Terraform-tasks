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
  name     = "anu_db"
  location = "Central US"
}
# Azure Database for MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "example" {
  name                   = "example-mysql-server"
  resource_group_name    = azurerm_resource_group.example.name
  location               = azurerm_resource_group.example.location
  administrator_login    = "anu30122024"
  administrator_password = "Ads@123456"  # Use a secure password here
  version                = "8.0"

  # Configure the SKU and storage
  sku_name   = "Standard_B1ms"
  storage_mb = 20000  # 20GB

  # Configure backup retention
  backup_retention_days = 7

# MySQL Database inside the flexible server
resource "azurerm_mysql_flexible_database" "exampledb" {
  name                = "anu30122024"
  resource_group_name = azurerm_mysql_flexible_server.example.resource_group_name
  server_name         = azurerm_mysql_flexible_server.example.name
}


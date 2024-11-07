
provider "azurerm" {
    features {} 
 client_id       = "00000000"
 client_secret   = "00000000"
 tenant_id       = "00000000"
 subscription_id = "00000000"
}


resource "azurerm_resource_group" "example" {
  name     = "rg_anu"
  location = "East US"
}

resource "azurerm_container_registry" "example" {
  name                = "acranu01"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Basic"
  admin_enabled       = true
}

output "login_server" {
  value = azurerm_container_registry.example.login_server
}

output "admin_username" {
  value = azurerm_container_registry.example.admin_username
}

output "admin_password" {
  value = azurerm_container_registry.example.admin_password
  sensitive = true
}

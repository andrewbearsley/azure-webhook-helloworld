provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Create App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
}

# Create Web App for Containers
resource "azurerm_linux_web_app" "app" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    container_registry_use_managed_identity = true
    always_on = true
    
    application_stack {
      docker_image_name = "webhook:latest"
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
      docker_registry_username = azurerm_container_registry.acr.admin_username
      docker_registry_password = azurerm_container_registry.acr.admin_password
    }
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false",
    "PORT" = "8080",
    "WEBSITES_PORT" = "8080"
  }
  
  identity {
    type = "SystemAssigned"
  }
  
  # Docker configuration is now handled in site_config.application_stack
}



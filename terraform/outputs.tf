output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value     = azurerm_container_registry.acr.admin_username
  sensitive = true
}

output "acr_admin_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "webhook_url" {
  value = "https://${azurerm_linux_web_app.app.default_hostname}"
}

output "app_service_name" {
  value = azurerm_linux_web_app.app.name
}

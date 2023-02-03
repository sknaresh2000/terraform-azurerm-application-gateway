output "fqdn" {
  value = var.public_ip_name == null ? null : azurerm_public_ip.publicip[0].fqdn
}

output "ip_address" {
  value = var.public_ip_name == null ? null : azurerm_public_ip.publicip[0].ip_address
}

output "app_gateway_id" {
  value       = azurerm_application_gateway.app-gateway.id
  description = "The ID of the Application Gateway."
}
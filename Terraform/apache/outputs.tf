output "dns" {
  value = azurerm_public_ip.myterraformpublicip.domain_name_label  
}
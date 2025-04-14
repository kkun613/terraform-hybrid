resource "azurerm_dns_zone" "ysjang_dns" {
  name                = "kkun.store"
  resource_group_name = azurerm_resource_group.ysjang_rg.name
}
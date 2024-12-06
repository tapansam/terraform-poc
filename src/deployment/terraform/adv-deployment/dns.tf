locals {
  dns_prefix = var.env == "prod" ? "@" : "${var.env}"
}

data "azurerm_resource_group" "adv_dns_rg" {
  name = var.dns_zone.rg
}

data "azurerm_dns_zone" "adv" {
  name                = var.dns_zone.name
  resource_group_name = var.dns_zone.rg
}

resource "azurerm_dns_a_record" "adv" {
  name                = local.dns_prefix
  zone_name           = data.azurerm_dns_zone.adv.name
  resource_group_name = data.azurerm_resource_group.adv_dns_rg.name
  records             = [azurerm_public_ip.adv.ip_address]
  ttl                 = 300
}

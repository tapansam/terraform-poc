resource "azurerm_resource_group" "state" {
  name     = "rg-${var.prefix}-state"
  location = var.location
}

resource "azurerm_resource_group" "identity" {
  name     = "rg-${var.prefix}-identity"
  location = var.location
}

resource "azurerm_resource_group" "adv" {
  for_each = { for env in var.environments : env => env }
  name     = "rg-${var.prefix}-${each.value}"
  location = var.location
}

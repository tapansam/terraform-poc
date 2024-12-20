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

resource "azurerm_role_assignment" "adv" {
  for_each             = { for env in var.environments : env => env }
  scope                = azurerm_resource_group.adv[each.value].id
  role_definition_name = "Contributor"
  principal_id         = var.use_managed_identity ? azurerm_user_assigned_identity.adv[each.value].principal_id : azuread_service_principal.github_oidc[each.value].object_id
}

data "azurerm_resource_group" "adv_dns" {
  name = var.dns_zone.rg
}

resource "azurerm_role_assignment" "adv_dns" {
  for_each             = { for env in var.environments : env => env }
  scope                = data.azurerm_resource_group.adv_dns.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = var.use_managed_identity ? azurerm_user_assigned_identity.adv[each.value].principal_id : azuread_service_principal.github_oidc[each.value].object_id
}

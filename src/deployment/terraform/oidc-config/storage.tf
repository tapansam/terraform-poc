resource "random_string" "rand" {
  length  = 3
  special = false
  upper   = false
}

resource "azurerm_storage_account" "adv" {
  name                     = "${lower(replace(var.prefix, "-", ""))}tfstate${random_string.rand.result}"
  resource_group_name      = azurerm_resource_group.state.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "adv" {
  for_each              = { for env in var.environments : env => env }
  name                  = each.value
  storage_account_id    = azurerm_storage_account.adv.id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "storage_container" {
  for_each             = { for env in var.environments : env => env }
  scope                = azurerm_storage_container.adv[each.value].resource_manager_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.use_managed_identity ? azurerm_user_assigned_identity.adv[each.value].principal_id : azuread_service_principal.github_oidc[each.value].object_id
}

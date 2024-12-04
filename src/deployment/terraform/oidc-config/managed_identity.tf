resource "azurerm_user_assigned_identity" "adv" {
  for_each            = var.use_managed_identity ? { for env in var.environments : env => env } : {}
  name                = "${var.prefix}-${each.value}"
  location            = var.location
  resource_group_name = azurerm_resource_group.identity.name
}

resource "azurerm_federated_identity_credential" "adv" {
  for_each            = var.use_managed_identity ? { for env in var.environments : env => env } : {}
  name                = "${var.github_organisation_target}-${data.github_repository.adv.name}-${each.value}"
  resource_group_name = azurerm_resource_group.identity.name
  audience            = [local.default_audience_name]
  issuer              = local.github_issuer_url
  parent_id           = azurerm_user_assigned_identity.adv[each.value].id
  subject             = "repo:${var.github_organisation_target}/${data.github_repository.adv.name}:environment:${each.value}"
}

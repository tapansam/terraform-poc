resource "azuread_application" "github_oidc" {
  for_each     = var.use_managed_identity ? {} : { for env in var.environments : env => env }
  display_name = "${var.prefix}-${each.value}"
  api {
    requested_access_token_version = 2
  }
}

resource "azuread_service_principal" "github_oidc" {
  for_each  = var.use_managed_identity ? {} : { for env in var.environments : env => env }
  client_id = azuread_application.github_oidc[each.value].application_id
}

resource "azuread_application_federated_identity_credential" "github_oidc" {
  for_each       = var.use_managed_identity ? {} : { for env in var.environments : env => env }
  application_id = azuread_application.github_oidc[each.value].application_id
  display_name   = "${var.github_organisation_target}-${data.github_repository.adv.name}-${each.value}"
  description    = "Federated Identity Credential for deployment of ${var.github_organisation_target}/${data.github_repository.adv.name} for environment ${each.value}"
  audiences      = [local.default_audience_name]
  issuer         = local.github_issuer_url
  subject        = "repo:${var.github_organisation_target}/${data.github_repository.adv.name}:environment:${each.value}"
}

data "github_repository" "adv" {
  name = var.github_repository
}

resource "github_repository_environment" "adv" {
  for_each    = { for env in var.environments : env => env }
  environment = each.value
  repository  = data.github_repository.adv.name
}


resource "github_actions_environment_secret" "azure_client_id" {
  for_each        = { for env in var.environments : env => env }
  repository      = data.github_repository.adv.name
  environment     = github_repository_environment.adv[each.value].environment
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = var.use_managed_identity ? azurerm_user_assigned_identity.adv[each.value].client_id : azuread_application.github_oidc[each.value].client_id
}

resource "github_actions_environment_secret" "azure_subscription_id" {
  for_each        = { for env in var.environments : env => env }
  repository      = data.github_repository.adv.name
  environment     = github_repository_environment.adv[each.value].environment
  secret_name     = "AZURE_SUBSCRIPTION_ID"
  plaintext_value = data.azurerm_client_config.current.subscription_id
}

resource "github_actions_environment_secret" "azure_tenant_id" {
  for_each        = { for env in var.environments : env => env }
  repository      = data.github_repository.adv.name
  environment     = github_repository_environment.adv[each.value].environment
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = data.azurerm_client_config.current.tenant_id
}

resource "github_actions_environment_secret" "azure_resource_group_name" {
  for_each        = { for env in var.environments : env => env }
  repository      = data.github_repository.adv.name
  environment     = github_repository_environment.adv[each.value].environment
  secret_name     = "AZURE_RESOURCE_GROUP_NAME"
  plaintext_value = azurerm_resource_group.adv[each.value].name
}

resource "github_actions_environment_secret" "backend_azure_resource_group_name" {
  for_each        = { for env in var.environments : env => env }
  repository      = data.github_repository.adv.name
  environment     = github_repository_environment.adv[each.value].environment
  secret_name     = "BACKEND_AZURE_RESOURCE_GROUP_NAME"
  plaintext_value = azurerm_resource_group.state.name
}

resource "github_actions_environment_secret" "backend_azure_storage_account_name" {
  for_each        = { for env in var.environments : env => env }
  repository      = data.github_repository.adv.name
  environment     = github_repository_environment.adv[each.value].environment
  secret_name     = "BACKEND_AZURE_STORAGE_ACCOUNT_NAME"
  plaintext_value = azurerm_storage_account.adv.name
}

resource "github_actions_environment_secret" "backend_azure_storage_account_container_name" {
  for_each        = { for env in var.environments : env => env }
  repository      = data.github_repository.adv.name
  environment     = github_repository_environment.adv[each.value].environment
  secret_name     = "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME"
  plaintext_value = azurerm_storage_container.adv[each.value].name
}

resource "github_actions_environment_secret" "github_pattoken" {
  for_each        = { for env in var.environments : env => env }
  repository      = data.github_repository.adv.name
  environment     = github_repository_environment.adv[each.value].environment
  secret_name     = "PAT_TOKEN_GIT_INTEGRATION"
  plaintext_value = var.github_token
}

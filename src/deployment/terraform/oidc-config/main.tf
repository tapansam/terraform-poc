terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.12.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.0.2"
    }
    github = {
      source  = "integrations/github"
      version = "6.4.0"
    }
  }
}


provider "github" {
  token = var.github_token
  owner = var.github_organisation_target
}

provider "azurerm" {
  subscription_id = var.azure_subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}


provider "azuread" {
}

data "azurerm_client_config" "current" {}

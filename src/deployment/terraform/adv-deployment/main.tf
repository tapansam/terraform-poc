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
  backend "azurerm" {
    key      = "terraform.tfstate"
    use_oidc = true
  }
}

provider "azurerm" {
  use_oidc        = true
  subscription_id = var.subscription_id
  features {}
}

provider "azuread" {
}

provider "github" {
  token = var.github_token
  owner = var.github_organisation_target
}

data "azurerm_client_config" "current" {}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
  suffix  = [var.prefix, var.env]
}

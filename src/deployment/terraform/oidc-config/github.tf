data "github_repository" "adv" {
  name = var.github_repository
}

resource "github_repository_environment" "adv" {
  for_each    = { for env in var.environments : env => env }
  environment = each.value
  repository  = data.github_repository.adv.name
}


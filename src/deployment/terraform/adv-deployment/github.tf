data "github_repository_environments" "adv" {
  repository = var.github_repository
}

resource "github_actions_environment_secret" "vm_ssh_key" {
  repository      = var.github_repository
  environment     = var.env
  secret_name     = "VM_SSH_KEY"
  plaintext_value = tls_private_key.main.private_key_pem
}

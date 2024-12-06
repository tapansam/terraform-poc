variable "prefix" {
  type    = string
  default = "adv-tf-demo"
}

variable "azure_subscription_id" {
  type = string
}

variable "location" {
  type    = string
  default = "Central India"
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "github_organisation_target" {
  type    = string
  default = "tapansam"
}

variable "github_repository" {
  type    = string
  default = "terraform-poc"
}

variable "environments" {
  type    = list(string)
  default = ["dev", "test", "prod"]
}

variable "use_managed_identity" {
  type        = bool
  default     = true
  description = "If selected, this option will create and configure a user assigned managed identity in the subscription instead of an AzureAD service principal."
}

variable "dns_zone" {
  type = object({
    name = string,
    rg   = string
  })
  default = {
    name = "uttamgolds.in"
    rg   = "rg-central-india-core-resources"
  }
}

variable "prefix" {
  type    = string
  default = "advapp"
}

variable "env" {
  type = string
}

variable "subscription_id" {
  type      = string
  sensitive = true
}

variable "resource_group_name" {
  type      = string
  sensitive = true
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

variable "dns_zone" {
  type = object({
    name = string,
    rg   = string
  })
}

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
  type = string
}


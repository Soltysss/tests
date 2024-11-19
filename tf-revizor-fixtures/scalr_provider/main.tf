terraform {
  required_providers {
    scalr = {
      source  = "registry.scalr.io/scalr/scalr"
      version = "1.1.0"
    }
  }
}

variable "scalr_host_name" {}
variable "scalr_api_token" {}


provider "scalr" {
  hostname = var.scalr_host_name
  token    = var.scalr_api_token
}

resource "scalr_variable" "example" {
  key          = "my_key_name"
  value        = "my_value_name_second2"
  category     = "shell"
  description  = "variable description"
}


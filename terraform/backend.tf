terraform {
  required_version = ">= 1.1.0"
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "change_me"
    workspaces {
      name = "change_me"
    }
  }
}

terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "5.21.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 1.2.0"
}
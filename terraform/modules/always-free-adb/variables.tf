variable "db_name" {
  type = string
  default = ""
}

variable "db_workload" {
  type = string
  default = ""
}

variable "compartment_ocid" {
  type = string
  default = ""
}

variable "adb_nsg_ids" {
  default = ""
}

variable "adb_subnet_id" {
  default = ""
}

variable "password" {}

variable "is_free_tier" {}
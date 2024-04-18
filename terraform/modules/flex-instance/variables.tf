variable "instance_shape" {
  type = string
}

variable "instance_shape_config_ocpus" {
  type = string
}

variable "instance_shape_config_memory_in_gbs" {
  type = string
}

variable "instance_shape_config_baseline_ocpu_utilization" {}

variable "instance_shape_config_vcpus" {}

variable "ssh_public_key" {
}

variable "nsg_ids" {
}

variable "vcn_id" {
}

variable "subnet_id" {
}

variable "display_name"{
  }

variable "compartment_ocid" {
}

variable "region" {
  default = ""
}

variable "instance_image_ocid" {
}

variable "assign_public_ip" {}
variable "availability_domain" {}

variable "user_data" {
  description = "User data passed to cloud-init when the instance is started"
}

variable "preserve_boot_volume" {}
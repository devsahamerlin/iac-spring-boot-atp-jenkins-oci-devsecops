variable "dns_label" {}
variable "cidr_block" {}
variable "display_name" {}
variable "compartment_ocid" {}
variable "vcn_id" {}
variable "prohibit_public_ip_on_vnic" {}
variable "security_list_ids" {
  type = list(string)
}
variable "route_table_id" {}
variable "dhcp_options_id" {}
variable "availability_domain" {}

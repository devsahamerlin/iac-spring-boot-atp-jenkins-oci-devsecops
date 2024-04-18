resource "oci_core_subnet" "subnet" {
  cidr_block        = var.cidr_block
  display_name      = var.display_name
  compartment_id    = var.compartment_ocid
  vcn_id            = var.vcn_id
  route_table_id    = var.route_table_id
  security_list_ids = var.security_list_ids
  dhcp_options_id   = var.dhcp_options_id
  dns_label         = var.dns_label
  prohibit_public_ip_on_vnic = var.prohibit_public_ip_on_vnic
  availability_domain = var.availability_domain
}

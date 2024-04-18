output "id" {
  value = oci_core_vcn.vcn.id
}
output "default_route_table_id" {
  value = oci_core_vcn.vcn.default_route_table_id
}

output "default_security_list_id" {
  value = oci_core_vcn.vcn.default_security_list_id
}

output "default_dhcp_options_id" {
  value = oci_core_vcn.vcn.default_dhcp_options_id
}

output "cidr_block" {
  value = oci_core_vcn.vcn.cidr_block
}

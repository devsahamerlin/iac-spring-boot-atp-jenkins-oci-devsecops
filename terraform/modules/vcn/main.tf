resource "oci_core_vcn" "vcn" {
  dns_label      = var.dns_label
  cidr_block     = var.cidr_block
  compartment_id = var.compartment_ocid
  display_name   = var.display_name
}

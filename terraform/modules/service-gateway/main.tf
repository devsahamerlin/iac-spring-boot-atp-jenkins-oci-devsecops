resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = var.oci_compartment_id
  display_name   = "sgw-${var.display_name}"

  services {
    service_id = var.service_id
  }

  vcn_id = var.vcn_id
}
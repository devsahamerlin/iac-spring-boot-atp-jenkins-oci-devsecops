resource "oci_identity_compartment" "compartment" {
  # Required
  compartment_id = var.tenancy_ocid
  description = var.description
  name = var.name
}
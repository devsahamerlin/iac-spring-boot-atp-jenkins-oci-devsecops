data "oci_identity_availability_domain" "ad" {
  compartment_id = var.oci_tenancy_id_ocid
  ad_number      = 1
}
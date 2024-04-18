provider "oci" {
  tenancy_ocid = var.oci_tenancy_id_ocid
  user_ocid    = var.oci_user_id_ocid
  fingerprint  = var.oci_fingerprint_ocid
  private_key  = var.oci_private_key_ocid
  region       = var.oci_region
}
resource "oci_database_autonomous_database" "adb" {
  admin_password           = var.password
  compartment_id           = var.compartment_ocid
#  nsg_ids                  = var.adb_nsg_ids
#  subnet_id                = var.adb_subnet_id
  db_name                  = var.db_name
  display_name             = var.db_name
  db_workload              = var.db_workload
  is_free_tier             = var.is_free_tier
}
output "adb_password" {
  value = oci_database_autonomous_database.adb.admin_password
}

output "adb_connection_strings" {
  value = oci_database_autonomous_database.adb.connection_strings.0.all_connection_strings
}

output "apex_url" {
  value = oci_database_autonomous_database.adb.connection_urls.0.apex_url
}

output "db_infrastructure" {
  value = oci_database_autonomous_database.adb.infrastructure_type
}

output "id" {
  value = oci_database_autonomous_database.adb.id
}

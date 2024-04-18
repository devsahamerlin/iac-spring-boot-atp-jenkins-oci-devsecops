resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name = "igw-${var.display_name}" #"Internet Gateway New-VCN"
  vcn_id = var.vcn_id

  #Optional
#  enabled = var.enabled
#  defined_tags = {"Operations.CostCenter"= "42"}
#  freeform_tags = {"Department"= "Software Engineer"}
#  route_table_id = var.route_table_id
}
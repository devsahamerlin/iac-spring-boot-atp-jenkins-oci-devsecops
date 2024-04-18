
resource "oci_core_instance" "flex_vm" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = var.display_name
  shape               = var.instance_shape
  preserve_boot_volume = var.preserve_boot_volume

  shape_config {
    ocpus         = var.instance_shape_config_ocpus
    memory_in_gbs = var.instance_shape_config_memory_in_gbs

    baseline_ocpu_utilization = var.instance_shape_config_baseline_ocpu_utilization
    vcpus = var.instance_shape_config_vcpus
  }

  create_vnic_details {
    subnet_id        = var.subnet_id #data.oci_core_subnets.spoke_subnets.subnets[0].id
    display_name     = "${var.display_name}-nic"
    assign_public_ip = var.assign_public_ip
    nsg_ids          = var.nsg_ids
  }

  source_details {
    source_type = "image"
    source_id   = var.instance_image_ocid
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = var.user_data
  }

}

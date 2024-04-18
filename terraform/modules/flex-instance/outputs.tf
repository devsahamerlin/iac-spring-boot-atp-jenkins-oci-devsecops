output "oci_flex_fm" {
  value = oci_core_instance.flex_vm
}

output "oci_flex_vm_public_ip" {
  value = oci_core_instance.flex_vm.public_ip
}

output "oci_flex_vm_private_ip" {
  value = oci_core_instance.flex_vm.private_ip
}

output "display_name" {
  value = oci_core_instance.flex_vm.display_name
}

output "id" {
  value = oci_core_instance.flex_vm.id
}
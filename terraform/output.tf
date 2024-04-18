output "name-of-first-availability-domain" {
  value = data.oci_identity_availability_domain.ad.name
}

output "app-public_ip" {
  value = "http://${module.oci-app-vm.oci_flex_vm_public_ip}"
}

output "app-private_ip" {
  value = "http://${module.oci-app-vm.oci_flex_vm_private_ip}"
}

output "argocd_public_ip" {
  value = "http://${module.oci-app-vm.oci_flex_vm_public_ip}:8088"
}

output "sonar_public_ip" {
  value = "http://${module.oci-devops-vm.oci_flex_vm_public_ip}:8086"
}

output "jenkins_public_ip" {
  value = "http://${module.oci-devops-vm.oci_flex_vm_public_ip}:8080"
}

output "jenkins-private_ip" {
  value = "http://${module.oci-devops-vm.oci_flex_vm_private_ip}"
}

output "igw" {
  value = module.jenkins-internet_gateway.id
}

output "db_id" {
  value =  module.always-free-autonomous_db.id
}

output "adb_connection_strings" {
  value = module.always-free-autonomous_db.adb_connection_strings
}

output "generated_ssh_private_key" {
  value = tls_private_key.public_private_key_pair.private_key_pem
  sensitive = true
}

output "adb_apex_url" {
  value = module.always-free-autonomous_db.apex_url
}

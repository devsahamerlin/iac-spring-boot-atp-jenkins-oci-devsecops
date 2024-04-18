resource "tls_private_key" "public_private_key_pair" {
  algorithm = "RSA"
}

module "dev-compartment" {
  source       = "./modules/compartment"
  description  = "IaC dev team"
  name         = "jenkins-devsecops-always-free-oci"
  tenancy_ocid = var.oci_tenancy_id_ocid
}

module "dev-vcn" {
  source           = "./modules/vcn"
  cidr_block       = "10.0.0.0/16"
  compartment_ocid = module.dev-compartment.id
  display_name     = "iacserver-vcn"
  dns_label        = "iacservernet"
}

module "public_subnet" {
  source                     = "./modules/subnet"
  cidr_block                 = "10.0.1.0/24"
  display_name               = "iacserver_public_subnet"
  vcn_id                     = module.dev-vcn.id
  route_table_id             = oci_core_default_route_table.default_route_table.id #module.public_route_table.id
  security_list_ids          = [module.dev-vcn.default_security_list_id]
  dhcp_options_id            = module.dev-vcn.default_dhcp_options_id
  dns_label                  = "wp"
  compartment_ocid           = module.dev-compartment.id
  prohibit_public_ip_on_vnic = false
  availability_domain        = data.oci_identity_availability_domain.ad.name
}

module "oci-devops-vm" {
  source                                          = "./modules/flex-instance"
  vcn_id                                          = module.dev-vcn.id
  subnet_id                                       = module.public_subnet.id
  nsg_ids                                         = [module.oci_app_network_sec_group.nsg_id]
  compartment_ocid                                = module.dev-compartment.id
  ssh_public_key                                  = var.generate_public_ssh_key ? tls_private_key.public_private_key_pair.public_key_openssh : join("\n", [var.ssh_public_key, tls_private_key.public_private_key_pair.public_key_openssh])
  display_name                                    = "oci-devops-vm"
  region                                          = var.oci_region
  availability_domain                             = data.oci_identity_availability_domain.ad.name
  instance_shape                                  = "VM.Standard.A1.Flex"
  instance_shape_config_baseline_ocpu_utilization = "BASELINE_1_1"
  instance_shape_config_memory_in_gbs             = "12"
  instance_shape_config_ocpus                     = "2"
  instance_shape_config_vcpus                     = "2"

  user_data = base64encode(templatefile("${path.module}/script/userdata/devops-server.sh",
    {
      name = "oci-devops-vm"
      password = var.user_password
    }))

  preserve_boot_volume   = false
  instance_image_ocid    = var.instance_image_ocid[var.oci_region]
  assign_public_ip       = true
}

module "oci-app-vm" {
  source                                          = "./modules/flex-instance"
  vcn_id                                          = module.dev-vcn.id
  subnet_id                                       = module.public_subnet.id
  nsg_ids                                         = [module.oci_app_network_sec_group.nsg_id]
  compartment_ocid                                = module.dev-compartment.id
  ssh_public_key                                  = var.generate_public_ssh_key ? tls_private_key.public_private_key_pair.public_key_openssh : join("\n", [var.ssh_public_key, tls_private_key.public_private_key_pair.public_key_openssh])
  display_name                                    = "oci-app-vm"
  region                                          = var.oci_region
  availability_domain                             = data.oci_identity_availability_domain.ad.name
  instance_shape                                  = "VM.Standard.A1.Flex"
  instance_shape_config_baseline_ocpu_utilization = "BASELINE_1_1"
  instance_shape_config_memory_in_gbs             = "12"
  instance_shape_config_ocpus                     = "2"
  instance_shape_config_vcpus                     = "2"

  user_data              = base64encode(templatefile("${path.module}/script/userdata/init-bootstrap-server.sh",
    {
      name = "oci-app-vm"
      password = var.user_password
    }))
  preserve_boot_volume   = false
  instance_image_ocid    = var.instance_image_ocid[var.oci_region]
  assign_public_ip       = true
}

# Autonomous
module "always-free-autonomous_db" {
  source           = "./modules/always-free-adb"
  adb_nsg_ids      = [module.oci_db_network_sec_group.nsg_id]
  db_workload      = var.oci_db_workload # OLTP, DW, AJD, APEX
  db_name          = var.oci_db_name
  compartment_ocid = module.dev-compartment.id
  password         = var.autonomous_database_admin_password
  is_free_tier     = true
}

resource "oci_database_autonomous_database_wallet" "autonomous_autonomous_database_wallet" {
  #Required
  autonomous_database_id = module.always-free-autonomous_db.id
  password = var.autonomous_database_admin_password

  #Optional
  base64_encode_content = "false"
  generate_type = "SINGLE" # SINGLE, ALL
}

module "jenkins-internet_gateway" {
  source           = "./modules/internet-gateway"
  compartment_ocid = module.dev-compartment.id
  display_name     = "jenkins"
  enabled          = true
  vcn_id           = module.dev-vcn.id
  route_table_id   = oci_core_default_route_table.default_route_table.id
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = module.dev-vcn.default_route_table_id
  display_name               = "IaCDefaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = module.jenkins-internet_gateway.id
  }
}

module "oci_app_network_sec_group" {
  source           = "./modules/network-security-groups"
  compartment_ocid = module.dev-compartment.id
  nsg_display_name = "${var.oci_app_name}-nsg"
  nsg_whitelist_ip = "0.0.0.0/0"
  vcn_id           = module.dev-vcn.id
  vcn_cidr_block   = "0.0.0.0/0"
}

module "allow-nsg-8080-8089-rule" {
  source                     = "./modules/tcp-nsg-rules"
  description                = "8080-8089 Ingress"
  destination_max_port_range = "8089"
  destination_min_port_range = "8080"
  direction                  = "INGRESS"
  network_security_group_id  = module.oci_app_network_sec_group.nsg_id
  protocol                   = "6"
  source_range               = "0.0.0.0/0"
  stateless                  = false
}

module "allow-nsg-80-rule" {
  source                     = "./modules/tcp-nsg-rules"
  description                = "80 Ingress"
  destination_max_port_range = "80"
  destination_min_port_range = "80"
  direction                  = "INGRESS"
  network_security_group_id  = module.oci_app_network_sec_group.nsg_id
  protocol                   = "6"
  source_range               = "0.0.0.0/0"
  stateless                  = false
}

module "allow-nsg-22-rule" {
  source                     = "./modules/tcp-nsg-rules"
  description                = "SSH Ingress"
  destination_max_port_range = "22"
  destination_min_port_range = "22"
  direction                  = "INGRESS"
  network_security_group_id  = module.oci_app_network_sec_group.nsg_id
  protocol                   = "6"
  source_range               = "0.0.0.0/0"
  stateless                  = false
}

module "oci_db_network_sec_group" {
  source           = "./modules/network-security-groups"
  compartment_ocid = module.dev-compartment.id
  nsg_display_name = "${var.oci_db_name}-nsg"
  nsg_whitelist_ip = module.dev-vcn.cidr_block
  vcn_id           = module.dev-vcn.id
  vcn_cidr_block   = module.dev-vcn.cidr_block
}

resource "time_sleep" "wait_5_minutes" {
  depends_on = [module.oci-devops-vm]

  create_duration = "5m"
}

resource "null_resource" "devops_provisioner" {

  depends_on = [module.oci-devops-vm, time_sleep.wait_5_minutes]

  provisioner "file" {
    content     = tls_private_key.public_private_key_pair.private_key_pem
    destination = "/home/ubuntu/private"

    connection {
      type        = "ssh"
      host        = module.oci-devops-vm.oci_flex_vm_public_ip
      agent       = false
      timeout     = "5m"
      user        = "ubuntu"
      private_key = tls_private_key.public_private_key_pair.private_key_pem

    }
  }

  provisioner "file" {
    content     = file("${path.module}/script/docker-docker-compose.yml")
    destination = "/home/ubuntu/docker-docker-compose.yml"

    connection {
      type        = "ssh"
      host        = module.oci-devops-vm.oci_flex_vm_public_ip
      agent       = false
      timeout     = "5m"
      user        = "ubuntu"
      private_key = tls_private_key.public_private_key_pair.private_key_pem

    }
  }

  provisioner "file" {
    content     = file("${path.module}/script/maven.yml")
    destination = "/home/ubuntu/maven.yml"

    connection {
      type        = "ssh"
      host        = module.oci-devops-vm.oci_flex_vm_public_ip
      agent       = false
      timeout     = "5m"
      user        = "ubuntu"
      private_key = tls_private_key.public_private_key_pair.private_key_pem

    }
  }

  provisioner "file" {
    content     = file("${path.module}/script/sonarqube.yml")
    destination = "/home/ubuntu/sonarqube.yml"

    connection {
      type        = "ssh"
      host        = module.oci-devops-vm.oci_flex_vm_public_ip
      agent       = false
      timeout     = "5m"
      user        = "ubuntu"
      private_key = tls_private_key.public_private_key_pair.private_key_pem

    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = module.oci-devops-vm.oci_flex_vm_public_ip
      agent       = false
      timeout     = "5m"
      user        = "ubuntu"
      private_key = tls_private_key.public_private_key_pair.private_key_pem

    }

    inline = [
      "sudo ansible-playbook /home/ubuntu/docker-docker-compose.yml",
      "sudo ansible-playbook /home/ubuntu/maven.yml",
      "sudo docker-compose -f /home/ubuntu/sonarqube.yml up -d",
    ]
  }
}


resource "null_resource" "app-server-config" {
  depends_on = [time_sleep.wait_5_minutes]

  provisioner "file" {
    content     = tls_private_key.public_private_key_pair.private_key_pem
    destination = "/home/ubuntu/private"

    connection {
      type        = "ssh"
      host        = module.oci-app-vm.oci_flex_vm_public_ip
      agent       = false
      timeout     = "5m"
      user        = "ubuntu"
      private_key = tls_private_key.public_private_key_pair.private_key_pem

    }
  }

  provisioner "file" {
    content     = file("${path.module}/script/argoCDinstall.yaml")
    destination = "/home/ubuntu/argoCDinstall.yaml"

    connection {
      type        = "ssh"
      host        = module.oci-app-vm.oci_flex_vm_public_ip
      agent       = false
      timeout     = "5m"
      user        = "ubuntu"
      private_key = tls_private_key.public_private_key_pair.private_key_pem

    }
  }

  provisioner "file" {
    content     = file("${path.module}/script/docker-docker-compose.yml")
    destination = "/home/ubuntu/docker-docker-compose.yml"

    connection {
      type        = "ssh"
      host        = module.oci-app-vm.oci_flex_vm_public_ip
      agent       = false
      timeout     = "5m"
      user        = "ubuntu"
      private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
  }

  provisioner "file" {
    content     = file("${path.module}/script/maven.yml")
    destination = "/home/ubuntu/maven.yml"

    connection {
      type        = "ssh"
      host        = module.oci-app-vm.oci_flex_vm_public_ip
      agent       = false
      timeout     = "5m"
      user        = "ubuntu"
      private_key = tls_private_key.public_private_key_pair.private_key_pem

    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = module.oci-app-vm.oci_flex_vm_public_ip
      agent       = false
      timeout     = "5m"
      user        = "ubuntu"
      private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    inline = [
      "sudo ansible-playbook /home/ubuntu/docker-docker-compose.yml",
      "sudo ansible-playbook /home/ubuntu/maven.yml"
    ]
  }
}

resource "null_resource" "install_argocd" {
  depends_on = [null_resource.devops_provisioner]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = module.oci-app-vm.oci_flex_vm_public_ip
      agent       = false
      timeout     = "5m"
      user        = "ubuntu"
      private_key = tls_private_key.public_private_key_pair.private_key_pem

    }
    inline = [
      "minikube start --driver=docker",
      "kubectl create ns argocd",
      "kubectl apply -n argocd -f /home/ubuntu/argoCDinstall.yaml",
    ]
  }
}

resource "time_sleep" "wait_2_minutes" {
  depends_on = [null_resource.install_argocd]

  create_duration = "2m"
}

resource "null_resource" "jenkins_Default_Password" {
  depends_on = [time_sleep.wait_2_minutes]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = module.oci-devops-vm.oci_flex_vm_public_ip
      agent       = false
      timeout     = "5m"
      user        = "ubuntu"
      private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = [
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
    ]
  }
}

resource "null_resource" "ArgoCD_Default_Password" {
  depends_on = [time_sleep.wait_2_minutes]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = module.oci-app-vm.oci_flex_vm_public_ip
      agent       = false
      timeout     = "5m"
      user        = "ubuntu"
      private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = [
      "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
    ]
  }
}

resource "null_resource" "forward_ArgoCD_Default_Password" {
  depends_on = [null_resource.ArgoCD_Default_Password]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = module.oci-app-vm.oci_flex_vm_public_ip
      agent       = false
      timeout     = "5m"
      user        = "ubuntu"
      private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = [
      "kubectl port-forward svc/argocd-server -n argocd --address 0.0.0.0 8088:443 >> /dev/null 2>&1 &"
    ]
  }
}
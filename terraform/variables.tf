variable "generate_public_ssh_key" {
  default = false
}

variable "public_ssh_key" {
  default = ""
}

variable "availability_domain_name" {
  default = null
}

variable "jenkins_password" {
  description = "Password for Jenkins admin user"
}

variable "oci_tenancy_id_ocid" {
  type = string
}

variable "oci_user_id_ocid" {
  type = string
}

variable "oci_fingerprint_ocid" {
  type = string
}

variable "oci_private_key_ocid" {
  type = string
}

variable "oci_compartment_id_ocid" {
  type = string
}

variable "oci_region" {
  type = string
}

variable "user_password" {}

variable "oci_instance_key_path" {
  type = string
}

variable "autonomous_database_admin_password" {
  type = string
}


variable "oci_app_name" {
  default = "oci-jenkins-vm"
}

variable "oci_db_name" {
  default = "ociATPDBSpringCICDApp"
}

variable "oci_db_workload" {
  default = "OLTP"
}
variable "instance_image_ocid" {
  type = map(string)
  default = {
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaa6hooptnlbfwr5lwemqjbu3uqidntrlhnt45yihfj222zahe7p3wq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaa6tp7lhyrcokdtf7vrbmxyp2pctgg4uxvt4jz4vc47qoc2ec4anha"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaadvi77prh3vjijhwe5xbd6kjg3n5ndxjcpod6om6qaiqeu3csof7a"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaaw5gvriwzjhzt2tnylrfnpanz5ndztyrv3zpwhlzxdbkqsjfkwxaq"
    eu-marseille-1-aarch64 = "ocid1.image.oc1.eu-marseille-1.aaaaaaaa457toyb4brqmdbcjdvjchspijbpjb3rubfddf7cgqrpfmjp55txq" # ubuntu aarch64
    eu-marseille-1 = "ocid1.image.oc1.eu-marseille-1.aaaaaaaaqihfeepadhdma7udc7n2vlfmienfwim4vl53dkftvfikrlxfi3ca" # good ubuntu
  }
}

variable "ssh_public_key" {}

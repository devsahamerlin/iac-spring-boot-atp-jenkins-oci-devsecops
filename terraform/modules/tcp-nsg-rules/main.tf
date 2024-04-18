resource "oci_core_network_security_group_security_rule" "rule" {
  network_security_group_id = var.network_security_group_id
  protocol                  = var.protocol
  description               = var.description
  direction                 = var.direction
  source                    = var.source_range
  stateless                 = var.stateless

  tcp_options {
    destination_port_range {
      min = var.destination_min_port_range
      max = var.destination_max_port_range
    }
  }
}
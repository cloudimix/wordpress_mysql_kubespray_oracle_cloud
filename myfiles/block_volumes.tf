resource "oci_core_volume_attachment" "attachment_wp_node" {
  attachment_type                     = "paravirtualized"
  device                              = "/dev/oracleoci/oraclevdb"
  display_name                        = "attachment_wp_node"
  instance_id                         = oci_core_instance.node[0].id
  is_pv_encryption_in_transit_enabled = "false"
  is_read_only                        = "false"
  is_shareable                        = var.is_shareable
  volume_id                           = oci_core_volume.wp_bv.id
}

resource "oci_core_volume_attachment" "attachment_sql_node" {
  attachment_type                     = "paravirtualized"
  device                              = "/dev/oracleoci/oraclevdc"
  display_name                        = "attachment_mysql_node"
  instance_id                         = oci_core_instance.node[0].id
  is_pv_encryption_in_transit_enabled = "false"
  is_read_only                        = "false"
  is_shareable                        = var.is_shareable
  volume_id                           = oci_core_volume.sql_bv.id
}

resource "oci_core_volume" "wp_bv" {
  availability_domain  = data.oci_identity_availability_domain.oVBc-EU-FRANKFURT-1-AD-2.name
  compartment_id       = var.compartment_ocid
  display_name         = "WordPress_BV"
  is_auto_tune_enabled = "false"
  size_in_gbs          = "50"
  vpus_per_gb          = "10"
}

resource "oci_core_volume" "sql_bv" {
  availability_domain  = data.oci_identity_availability_domain.oVBc-EU-FRANKFURT-1-AD-2.name
  compartment_id       = var.compartment_ocid
  display_name         = "MySQL_BV"
  is_auto_tune_enabled = "false"
  size_in_gbs          = "50"
  vpus_per_gb          = "10"
}

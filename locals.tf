locals {
  # Common tags to apply to all resources
  common_tags = concat(
    var.tags,
    [
      "environment:sandbox",
      "managed-by:terraform",
      "project:power-migration-lab"
    ]
  )

  # Resource naming with prefix
  resource_group_name = var.create_resource_group ? "${var.prefix}-${var.resource_group_name}" : var.resource_group_name
  cos_instance_name   = "${var.prefix}-${var.cos_instance_name}"
  cos_bucket_name     = "${var.prefix}-${var.cos_bucket_name}-${random_string.suffix.result}"
  vpc_name            = "${var.prefix}-${var.vpc_name}"
  bastion_name        = "${var.prefix}-${var.bastion_name}"
  ssh_key_name        = "${var.prefix}-ssh-key"

  # PowerVS naming
  powervs_workspace_name        = "${var.prefix}-${var.powervs_workspace_name}"
  powervs_service_instance_name = "${var.prefix}-${var.powervs_service_instance_name}"
  powervs_network_name          = "${var.prefix}-${var.powervs_network_name}"
  powervs_ssh_key_name          = "${var.prefix}-powervs-ssh-key"

  # AIX instance names
  aix_source_name = "${var.prefix}-${var.aix_source_name}"
  aix_target_name = "${var.prefix}-${var.aix_target_name}"
  aix_nim_name    = "${var.prefix}-${var.aix_nim_name}"

  # Volume names
  source_data_volume_name = "${local.aix_source_name}-data"
  target_data_volume_name = "${local.aix_target_name}-data"
  nim_data_volume_name    = "${local.aix_nim_name}-data"

  # Security group rules
  security_group_rules = [
    {
      name      = "allow-ssh-inbound"
      direction = "inbound"
      remote    = var.allowed_ssh_cidr
      tcp = {
        port_min = 22
        port_max = 22
      }
    },
    {
      name      = "allow-all-outbound"
      direction = "outbound"
      remote    = "0.0.0.0/0"
    }
  ]
}

# Random suffix for globally unique names (like COS bucket)
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
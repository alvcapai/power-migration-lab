# ==========================================
# SSH Key
# ==========================================

resource "ibm_is_ssh_key" "ssh_key" {
  count          = var.create_bastion ? 1 : 0
  name           = var.ssh_key_name
  public_key     = var.ssh_public_key
  resource_group = var.resource_group_id
  tags           = var.tags
}

# ==========================================
# Bastion VSI
# ==========================================

resource "ibm_is_instance" "bastion" {
  count          = var.create_bastion ? 1 : 0
  name           = var.bastion_name
  vpc            = var.vpc_id
  zone           = var.zone
  profile        = var.bastion_profile
  image          = data.ibm_is_image.bastion_image[0].id
  resource_group = var.resource_group_id
  tags           = var.tags

  primary_network_interface {
    subnet          = var.subnet_id
    security_groups = [var.security_group_id]
  }

  keys = [ibm_is_ssh_key.ssh_key[0].id]

  boot_volume {
    name = "${var.bastion_name}-boot"
  }
}

# ==========================================
# Floating IP for Bastion
# ==========================================

resource "ibm_is_floating_ip" "bastion_fip" {
  count          = var.create_bastion ? 1 : 0
  name           = "${var.bastion_name}-fip"
  target         = ibm_is_instance.bastion[0].primary_network_interface[0].id
  resource_group = var.resource_group_id
  tags           = var.tags
}

# ==========================================
# Data Source for Bastion Image
# ==========================================

data "ibm_is_image" "bastion_image" {
  count = var.create_bastion ? 1 : 0
  name  = var.bastion_image
}

# ==========================================
# Locals
# ==========================================

locals {
  bastion_id         = var.create_bastion ? ibm_is_instance.bastion[0].id : null
  bastion_name       = var.create_bastion ? ibm_is_instance.bastion[0].name : null
  bastion_public_ip  = var.create_bastion ? ibm_is_floating_ip.bastion_fip[0].address : null
  bastion_private_ip = var.create_bastion ? ibm_is_instance.bastion[0].primary_network_interface[0].primary_ip[0].address : null
}
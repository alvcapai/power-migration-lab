# ==========================================
# VPC
# ==========================================

resource "ibm_is_vpc" "vpc" {
  count                       = var.create_vpc ? 1 : 0
  name                        = var.vpc_name
  resource_group              = var.resource_group_id
  address_prefix_management   = "manual"
  default_security_group_name = "${var.vpc_name}-default-sg"
  default_network_acl_name    = "${var.vpc_name}-default-acl"
  default_routing_table_name  = "${var.vpc_name}-default-rt"
  tags                        = var.tags
}

# ==========================================
# VPC Address Prefix
# ==========================================

resource "ibm_is_vpc_address_prefix" "prefix" {
  count = var.create_vpc ? 1 : 0
  name  = "${var.vpc_name}-prefix"
  vpc   = ibm_is_vpc.vpc[0].id
  zone  = var.zone
  cidr  = var.vpc_address_prefix_cidr
}

# ==========================================
# VPC Subnet
# ==========================================

resource "ibm_is_subnet" "subnet" {
  count                    = var.create_vpc ? 1 : 0
  name                     = "${var.vpc_name}-subnet"
  vpc                      = ibm_is_vpc.vpc[0].id
  zone                     = var.zone
  ipv4_cidr_block          = var.vpc_subnet_cidr
  resource_group           = var.resource_group_id
  public_gateway           = ibm_is_public_gateway.gateway[0].id
  tags                     = var.tags

  depends_on = [ibm_is_vpc_address_prefix.prefix]
}

# ==========================================
# Public Gateway
# ==========================================

resource "ibm_is_public_gateway" "gateway" {
  count          = var.create_vpc ? 1 : 0
  name           = "${var.vpc_name}-gateway"
  vpc            = ibm_is_vpc.vpc[0].id
  zone           = var.zone
  resource_group = var.resource_group_id
  tags           = var.tags
}

# ==========================================
# Security Group
# ==========================================

resource "ibm_is_security_group" "security_group" {
  count          = var.create_vpc ? 1 : 0
  name           = "${var.vpc_name}-sg"
  vpc            = ibm_is_vpc.vpc[0].id
  resource_group = var.resource_group_id
  tags           = var.tags
}

# ==========================================
# Security Group Rules
# ==========================================

resource "ibm_is_security_group_rule" "rules" {
  for_each = var.create_vpc ? { for idx, rule in var.security_group_rules : idx => rule } : {}

  group     = ibm_is_security_group.security_group[0].id
  direction = each.value.direction
  remote    = each.value.remote

  dynamic "tcp" {
    for_each = lookup(each.value, "tcp", null) != null ? [each.value.tcp] : []
    content {
      port_min = lookup(tcp.value, "port_min", null)
      port_max = lookup(tcp.value, "port_max", null)
    }
  }

  dynamic "udp" {
    for_each = lookup(each.value, "udp", null) != null ? [each.value.udp] : []
    content {
      port_min = lookup(udp.value, "port_min", null)
      port_max = lookup(udp.value, "port_max", null)
    }
  }

  dynamic "icmp" {
    for_each = lookup(each.value, "icmp", null) != null ? [each.value.icmp] : []
    content {
      type = lookup(icmp.value, "type", null)
      code = lookup(icmp.value, "code", null)
    }
  }
}

# ==========================================
# Locals
# ==========================================

locals {
  vpc_id            = var.create_vpc ? ibm_is_vpc.vpc[0].id : null
  vpc_name          = var.create_vpc ? ibm_is_vpc.vpc[0].name : null
  subnet_id         = var.create_vpc ? ibm_is_subnet.subnet[0].id : null
  subnet_cidr       = var.create_vpc ? ibm_is_subnet.subnet[0].ipv4_cidr_block : null
  security_group_id = var.create_vpc ? ibm_is_security_group.security_group[0].id : null
}
# ==========================================
# Resource Group
# ==========================================

# Data source to get existing resource group
data "ibm_resource_group" "existing" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

# Create new resource group if requested
resource "ibm_resource_group" "new" {
  count = var.create_resource_group ? 1 : 0
  name  = var.resource_group_name
  tags  = var.tags
}

# Local to determine which resource group to use
locals {
  resource_group_id = var.create_resource_group ? ibm_resource_group.new[0].id : data.ibm_resource_group.existing[0].id
  resource_group_name = var.resource_group_name
}
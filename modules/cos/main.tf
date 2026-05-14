# ==========================================
# Cloud Object Storage Instance
# ==========================================

resource "ibm_resource_instance" "cos" {
  count             = var.create_cos ? 1 : 0
  name              = var.cos_instance_name
  service           = "cloud-object-storage"
  plan              = var.cos_plan
  location          = "global"
  resource_group_id = var.resource_group_id
  tags              = var.tags
}

# ==========================================
# COS Bucket
# ==========================================

resource "ibm_cos_bucket" "migration_artifacts" {
  count                = var.create_cos ? 1 : 0
  bucket_name          = var.cos_bucket_name
  resource_instance_id = ibm_resource_instance.cos[0].id
  region_location      = var.region
  storage_class        = var.cos_bucket_storage_class

  # Enable versioning for safety
  object_versioning {
    enable = true
  }

  # Activity tracking for audit
  activity_tracking {
    read_data_events     = true
    write_data_events    = true
    activity_tracker_crn = null
  }
}

# ==========================================
# Locals
# ==========================================

locals {
  cos_instance_id  = var.create_cos ? ibm_resource_instance.cos[0].id : null
  cos_instance_crn = var.create_cos ? ibm_resource_instance.cos[0].crn : null
  cos_bucket_name  = var.create_cos ? ibm_cos_bucket.migration_artifacts[0].bucket_name : null
  cos_bucket_region = var.create_cos ? ibm_cos_bucket.migration_artifacts[0].region_location : null
}
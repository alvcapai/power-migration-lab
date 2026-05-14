# ==========================================
# General Configuration
# ==========================================

variable "region" {
  description = "IBM Cloud region for VPC resources (e.g., us-south, eu-de)"
  type        = string
  default     = "us-south"
}

variable "zone" {
  description = "IBM Cloud zone for VPC resources (e.g., us-south-1, eu-de-1)"
  type        = string
  default     = "us-south-1"
}

variable "resource_group_name" {
  description = "Name of the IBM Cloud Resource Group to use or create"
  type        = string
  default     = "power-migration-lab"
}

variable "create_resource_group" {
  description = "Whether to create a new resource group (true) or use an existing one (false)"
  type        = bool
  default     = true
}

variable "prefix" {
  description = "Prefix to add to all resource names for identification"
  type        = string
  default     = "pml"

  validation {
    condition     = length(var.prefix) <= 10 && can(regex("^[a-z][a-z0-9-]*$", var.prefix))
    error_message = "Prefix must be lowercase alphanumeric with hyphens, start with a letter, and be max 10 characters."
  }
}

variable "tags" {
  description = "List of tags to apply to all resources"
  type        = list(string)
  default     = ["power-migration", "sandbox", "terraform"]
}

# ==========================================
# SSH Configuration
# ==========================================

variable "use_existing_ssh_key" {
  description = "Whether to use an existing SSH key (true) or create a new one (false)"
  type        = bool
  default     = false
}

variable "existing_ssh_key_name" {
  description = "Name of existing SSH key in IBM Cloud (required if use_existing_ssh_key is true)"
  type        = string
  default     = ""
}

variable "ssh_public_key" {
  description = "SSH public key content for creating new SSH key (required if use_existing_ssh_key is false)"
  type        = string
  default     = ""
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into bastion (restrict to your IP in production)"
  type        = string
  default     = "0.0.0.0/0"
}

# ==========================================
# Cloud Object Storage Configuration
# ==========================================

variable "create_cos" {
  description = "Whether to create a new Cloud Object Storage instance"
  type        = bool
  default     = true
}

variable "cos_instance_name" {
  description = "Name for the Cloud Object Storage instance"
  type        = string
  default     = "migration-artifacts"
}

variable "cos_bucket_name" {
  description = "Name for the COS bucket to store migration artifacts"
  type        = string
  default     = "migration-artifacts"
}

variable "cos_plan" {
  description = "Service plan for Cloud Object Storage (standard, lite)"
  type        = string
  default     = "standard"
}

variable "cos_bucket_storage_class" {
  description = "Storage class for COS bucket (standard, vault, cold, smart)"
  type        = string
  default     = "standard"
}

# ==========================================
# VPC Configuration
# ==========================================

variable "create_vpc" {
  description = "Whether to create a new VPC"
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = "sandbox"
}

variable "vpc_subnet_cidr" {
  description = "CIDR block for the VPC subnet"
  type        = string
  default     = "10.240.0.0/24"
}

variable "vpc_address_prefix_cidr" {
  description = "CIDR block for the VPC address prefix"
  type        = string
  default     = "10.240.0.0/16"
}

# ==========================================
# Bastion/Staging VSI Configuration
# ==========================================

variable "create_bastion" {
  description = "Whether to create a bastion/staging VSI"
  type        = bool
  default     = true
}

variable "bastion_name" {
  description = "Name for the bastion/staging VSI"
  type        = string
  default     = "bastion"
}

variable "bastion_profile" {
  description = "Profile for the bastion VSI (e.g., cx2-2x4)"
  type        = string
  default     = "cx2-2x4"
}

variable "bastion_image" {
  description = "Image name for the bastion VSI (e.g., ibm-ubuntu-22-04-minimal-amd64-1)"
  type        = string
  default     = "ibm-ubuntu-22-04-3-minimal-amd64-1"
}

# ==========================================
# PowerVS Workspace Configuration
# ==========================================

variable "powervs_workspace_name" {
  description = "Name for the PowerVS workspace"
  type        = string
  default     = "migration-lab"
}

variable "powervs_service_instance_name" {
  description = "Name for the PowerVS service instance"
  type        = string
  default     = "migration-lab"
}

variable "powervs_datacenter" {
  description = "PowerVS datacenter location (e.g., dal12, lon06, syd04)"
  type        = string
  default     = "dal12"
}

variable "powervs_zone" {
  description = "PowerVS zone (e.g., us-south, eu-gb, au-syd)"
  type        = string
  default     = "us-south"
}

variable "powervs_network_name" {
  description = "Name for the PowerVS private network"
  type        = string
  default     = "private-net"
}

variable "powervs_network_cidr" {
  description = "CIDR block for the PowerVS private network"
  type        = string
  default     = "192.168.100.0/24"
}

variable "powervs_network_type" {
  description = "Type of PowerVS network (vlan)"
  type        = string
  default     = "vlan"
}

variable "powervs_network_dns" {
  description = "DNS servers for PowerVS network"
  type        = list(string)
  default     = ["9.9.9.9", "1.1.1.1"]
}

variable "powervs_storage_pool" {
  description = "Storage pool for PowerVS volumes (Tier1 or Tier3)"
  type        = string
  default     = "Tier3"
}

# ==========================================
# AIX Configuration
# ==========================================

variable "aix_image_name" {
  description = "AIX image name available in the PowerVS datacenter (e.g., 7300-02-01)"
  type        = string
  default     = "7300-02-01"
}

variable "aix_source_name" {
  description = "Name for the AIX source instance"
  type        = string
  default     = "aix-src-01"
}

variable "aix_target_name" {
  description = "Name for the AIX target instance"
  type        = string
  default     = "aix-dst-01"
}

variable "aix_nim_name" {
  description = "Name for the AIX NIM instance (if created)"
  type        = string
  default     = "aix-nim-01"
}

variable "aix_source_processors" {
  description = "Number of processors for AIX source instance"
  type        = string
  default     = "0.5"
}

variable "aix_source_memory" {
  description = "Memory in GB for AIX source instance"
  type        = string
  default     = "4"
}

variable "aix_source_proc_type" {
  description = "Processor type for AIX source (shared or dedicated)"
  type        = string
  default     = "shared"
}

variable "aix_source_sys_type" {
  description = "System type for AIX source (s922, e980, etc.)"
  type        = string
  default     = "s922"
}

variable "aix_target_processors" {
  description = "Number of processors for AIX target instance"
  type        = string
  default     = "0.5"
}

variable "aix_target_memory" {
  description = "Memory in GB for AIX target instance"
  type        = string
  default     = "4"
}

variable "aix_target_proc_type" {
  description = "Processor type for AIX target (shared or dedicated)"
  type        = string
  default     = "shared"
}

variable "aix_target_sys_type" {
  description = "System type for AIX target (s922, e980, etc.)"
  type        = string
  default     = "s922"
}

variable "aix_nim_processors" {
  description = "Number of processors for AIX NIM instance"
  type        = string
  default     = "0.5"
}

variable "aix_nim_memory" {
  description = "Memory in GB for AIX NIM instance"
  type        = string
  default     = "4"
}

variable "aix_nim_proc_type" {
  description = "Processor type for AIX NIM (shared or dedicated)"
  type        = string
  default     = "shared"
}

variable "aix_nim_sys_type" {
  description = "System type for AIX NIM (s922, e980, etc.)"
  type        = string
  default     = "s922"
}

# ==========================================
# Storage Configuration
# ==========================================

variable "source_data_volume_size" {
  description = "Size in GB for additional data volume on source instance"
  type        = number
  default     = 20
}

variable "target_data_volume_size" {
  description = "Size in GB for additional data volume on target instance"
  type        = number
  default     = 20
}

variable "nim_data_volume_size" {
  description = "Size in GB for additional data volume on NIM instance"
  type        = number
  default     = 50
}

# ==========================================
# Feature Flags
# ==========================================

variable "create_nim" {
  description = "Whether to create an AIX NIM server instance"
  type        = bool
  default     = false
}
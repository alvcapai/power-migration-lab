variable "resource_group_id" {
  description = "ID of the resource group"
  type        = string
}

variable "powervs_workspace_name" {
  description = "Name for the PowerVS workspace"
  type        = string
}

variable "powervs_service_instance_name" {
  description = "Name for the PowerVS service instance"
  type        = string
}

variable "powervs_datacenter" {
  description = "PowerVS datacenter location"
  type        = string
}

variable "powervs_zone" {
  description = "PowerVS zone"
  type        = string
}

variable "powervs_network_name" {
  description = "Name for the PowerVS private network"
  type        = string
}

variable "powervs_network_cidr" {
  description = "CIDR block for the PowerVS private network"
  type        = string
}

variable "powervs_network_type" {
  description = "Type of PowerVS network"
  type        = string
}

variable "powervs_network_dns" {
  description = "DNS servers for PowerVS network"
  type        = list(string)
}

variable "powervs_storage_pool" {
  description = "Storage pool for PowerVS volumes"
  type        = string
}

variable "use_existing_ssh_key" {
  description = "Whether to use an existing SSH key"
  type        = bool
}

variable "existing_ssh_key_name" {
  description = "Name of existing SSH key"
  type        = string
}

variable "powervs_ssh_key_name" {
  description = "Name for the PowerVS SSH key (when creating new)"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key content (when creating new)"
  type        = string
}

variable "aix_image_name" {
  description = "AIX image name"
  type        = string
}

variable "aix_source_name" {
  description = "Name for the AIX source instance"
  type        = string
}

variable "aix_source_processors" {
  description = "Number of processors for AIX source"
  type        = string
}

variable "aix_source_memory" {
  description = "Memory in GB for AIX source"
  type        = string
}

variable "aix_source_proc_type" {
  description = "Processor type for AIX source"
  type        = string
}

variable "aix_source_sys_type" {
  description = "System type for AIX source"
  type        = string
}

variable "aix_target_name" {
  description = "Name for the AIX target instance"
  type        = string
}

variable "aix_target_processors" {
  description = "Number of processors for AIX target"
  type        = string
}

variable "aix_target_memory" {
  description = "Memory in GB for AIX target"
  type        = string
}

variable "aix_target_proc_type" {
  description = "Processor type for AIX target"
  type        = string
}

variable "aix_target_sys_type" {
  description = "System type for AIX target"
  type        = string
}

variable "aix_nim_name" {
  description = "Name for the AIX NIM instance"
  type        = string
}

variable "aix_nim_processors" {
  description = "Number of processors for AIX NIM"
  type        = string
}

variable "aix_nim_memory" {
  description = "Memory in GB for AIX NIM"
  type        = string
}

variable "aix_nim_proc_type" {
  description = "Processor type for AIX NIM"
  type        = string
}

variable "aix_nim_sys_type" {
  description = "System type for AIX NIM"
  type        = string
}

variable "source_data_volume_name" {
  description = "Name for the source data volume"
  type        = string
}

variable "source_data_volume_size" {
  description = "Size in GB for source data volume"
  type        = number
}

variable "target_data_volume_name" {
  description = "Name for the target data volume"
  type        = string
}

variable "target_data_volume_size" {
  description = "Size in GB for target data volume"
  type        = number
}

variable "nim_data_volume_name" {
  description = "Name for the NIM data volume"
  type        = string
}

variable "nim_data_volume_size" {
  description = "Size in GB for NIM data volume"
  type        = number
}

variable "create_nim" {
  description = "Whether to create an AIX NIM server"
  type        = bool
}

variable "tags" {
  description = "List of tags to apply to resources"
  type        = list(string)
  default     = []
}
variable "create_cos" {
  description = "Whether to create a new Cloud Object Storage instance"
  type        = bool
}

variable "resource_group_id" {
  description = "ID of the resource group"
  type        = string
}

variable "cos_instance_name" {
  description = "Name for the Cloud Object Storage instance"
  type        = string
}

variable "cos_bucket_name" {
  description = "Name for the COS bucket"
  type        = string
}

variable "cos_plan" {
  description = "Service plan for Cloud Object Storage"
  type        = string
}

variable "cos_bucket_storage_class" {
  description = "Storage class for COS bucket"
  type        = string
}

variable "region" {
  description = "IBM Cloud region for the bucket"
  type        = string
}

variable "tags" {
  description = "List of tags to apply to resources"
  type        = list(string)
  default     = []
}
variable "create_vpc" {
  description = "Whether to create a new VPC"
  type        = bool
}

variable "resource_group_id" {
  description = "ID of the resource group"
  type        = string
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "region" {
  description = "IBM Cloud region"
  type        = string
}

variable "zone" {
  description = "IBM Cloud zone"
  type        = string
}

variable "vpc_address_prefix_cidr" {
  description = "CIDR block for the VPC address prefix"
  type        = string
}

variable "vpc_subnet_cidr" {
  description = "CIDR block for the VPC subnet"
  type        = string
}

variable "security_group_rules" {
  description = "List of security group rules"
  type        = list(any)
  default     = []
}

variable "tags" {
  description = "List of tags to apply to resources"
  type        = list(string)
  default     = []
}
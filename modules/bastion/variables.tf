variable "create_bastion" {
  description = "Whether to create a bastion VSI"
  type        = bool
}

variable "resource_group_id" {
  description = "ID of the resource group"
  type        = string
}

variable "bastion_name" {
  description = "Name for the bastion VSI"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group"
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

variable "ssh_key_name" {
  description = "Name for the SSH key (when creating new)"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key content (when creating new)"
  type        = string
}

variable "bastion_profile" {
  description = "Profile for the bastion VSI"
  type        = string
}

variable "bastion_image" {
  description = "Image name for the bastion VSI"
  type        = string
}

variable "zone" {
  description = "IBM Cloud zone"
  type        = string
}

variable "tags" {
  description = "List of tags to apply to resources"
  type        = list(string)
  default     = []
}
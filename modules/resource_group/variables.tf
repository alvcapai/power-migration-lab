variable "create_resource_group" {
  description = "Whether to create a new resource group or use an existing one"
  type        = bool
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "List of tags to apply to the resource group"
  type        = list(string)
  default     = []
}
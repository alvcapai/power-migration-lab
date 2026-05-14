output "cos_instance_id" {
  description = "ID of the Cloud Object Storage instance"
  value       = local.cos_instance_id
}

output "cos_instance_crn" {
  description = "CRN of the Cloud Object Storage instance"
  value       = local.cos_instance_crn
}

output "cos_bucket_name" {
  description = "Name of the COS bucket"
  value       = local.cos_bucket_name
}

output "cos_bucket_region" {
  description = "Region of the COS bucket"
  value       = local.cos_bucket_region
}
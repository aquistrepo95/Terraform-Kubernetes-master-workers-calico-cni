/*
Outputs for AWS EFS module
*/

output "file_system_id" {
  description = "EFS file system ID"
  value       = aws_efs_file_system.efs-filesys-kubernetes.id
}

output "file_system_arn" {
  description = "EFS file system ARN"
  value       = aws_efs_file_system.efs-filesys-kubernetes.arn
}

output "dns_name" {
  description = "EFS file system DNS name"
  value       = aws_efs_file_system.efs-filesys-kubernetes.dns_name
}

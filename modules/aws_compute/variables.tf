# Variables for AWS compute module

variable "instance_tags" {
  description = "tags for the compute module"
  type        = map(string)  
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = map(string)
  default = {
    "master" = "t2.medium",
    "worker" = "t3.small"
  }
}

variable "worker_count" {
  description = "Number of worker nodes to create"
  type        = number
  default     = 2
  
}

variable "instance_subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "vpc_id_instance" {
  description = "value for the VPC ID"
  type        = string
}

variable "vpc_cidr_block" {
  description = "value for the VPC CIDR block" 
  type        = string
}

variable "efs_dns_name" {
  description = "DNS name of the EFS file system to be mounted on EC2 instances"
  type        = string
  
}
# Terraform configuration for AWS VPC and EC2 instances

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs             = [data.aws_availability_zones.available.names[0]]
  private_subnets = slice(var.private_subnet_cidr_blocks, 0, var.private_subnet_value)
  public_subnets  = slice(var.public_subnet_cidr_blocks, 0, var.public_subnet_value)

  enable_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}

module "ec2_instances" {
  source     = "./modules/aws_compute"
  depends_on = [module.vpc]

  instance_subnet_id = module.vpc.public_subnets[0]
  vpc_id_instance    = module.vpc.vpc_id
  vpc_cidr_block     = module.vpc.vpc_cidr_block
  efs_dns_name       = module.efs.dns_name

  instance_tags = var.tags

}

module "efs" {
  source     = "./modules/aws_efs"
  depends_on = [module.vpc]

  subnet_id_instance         = module.vpc.public_subnets[0]
  vpc_id_instance            = module.vpc.vpc_id
  instance_security_group_id = module.ec2_instances.security_group_id_workers

}

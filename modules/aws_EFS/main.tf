/*
EFS file system for Kubernetes cluster. This module creates an EFS file system, a security group to allow traffic between the EFS and the Kubernetes master node,
and a mount target in the specified subnet.
*/

resource "aws_efs_file_system" "efs-filesys-kubernetes" {
  creation_token    = var.creation_token
  encrypted         = true
  performance_mode  = "generalPurpose"

  tags = {
    Name = "kubernetes-efs"
  }
}

resource "aws_security_group" "kube-efs-sg" {
  name        = "allow_traffic_efs"
  description = "Allow inbound  and outbound traffic to k8s EFS file system"
  vpc_id      = var.vpc_id_instance

  tags = {
    Name = "allow_efs_traffic_sg"
  }
}


resource "aws_vpc_security_group_egress_rule" "kube-efs-file-sg-egress" {
  security_group_id = aws_security_group.kube-efs-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # all ports
}


resource "aws_vpc_security_group_ingress_rule" "kube_efs_file-nfs-ingress" {
    description                  = "Allow inbound traffic to EFS file system from master node"
    security_group_id            = aws_security_group.kube-efs-sg.id
    referenced_security_group_id = var.instance_security_group_id
    from_port                    = 2049
    ip_protocol                  = "tcp"
    to_port                      = 2049
}

resource "aws_efs_mount_target" "efs-filesys-kubernetes-mt" {
    file_system_id  = aws_efs_file_system.efs-filesys-kubernetes.id
    subnet_id       = var.subnet_id_instance
    security_groups = [aws_security_group.kube-efs-sg.id]
}


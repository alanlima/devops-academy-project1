resource "aws_efs_file_system" "this" {
  creation_token   = var.project
  throughput_mode  = "bursting"
  performance_mode = "generalPurpose"
  encrypted        = false
  tags = merge({
    Name = "${var.project}-wp-efs"
  }, var.common_tags)
}

resource "aws_efs_mount_target" "this" {
  count = length(var.private_subnets)

  file_system_id = aws_efs_file_system.this.id
  subnet_id      = var.private_subnets[count.index]
  security_groups = [
    aws_security_group.this.id
  ]
}

resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id
  root_directory {
    path = "/wordpress"
  }
}

resource "aws_security_group" "this" {
  description = "allow access to EFS"
  vpc_id      = var.vpc_id
  name        = "${var.project}-efs-sg"
  ingress {
    protocol    = "tcp"
    from_port   = 2049
    to_port     = 2049
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [var.ecs_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
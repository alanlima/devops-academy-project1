resource "aws_launch_template" "this" {
  name_prefix   = var.project
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_pair

  iam_instance_profile {
    arn = "arn:aws:iam::097922957316:instance-profile/ec2-ecs-role"
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.allow_internet.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "${var.project}-instance"
    })
  }

  user_data = base64encode(<<EOF
#! /bin/bash
yum update -y
echo ECS_CLUSTER=${aws_ecs_cluster.this.name} >> /etc/ecs/ecs.config;echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;
    EOF
  )
}

resource "aws_ecs_cluster" "this" {
  name = "${var.project}-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_autoscaling_group" "this" {
  desired_capacity    = 0
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.public_subnets

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "this" {
  autoscaling_group_name = aws_autoscaling_group.this.id
  alb_target_group_arn   = var.target_group_arn
}

resource "aws_security_group" "allow_internet" {
  name   = "allow web access sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #   ingress {
  #     from_port   = 22
  #     to_port     = 22
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon", "self"]
}

resource "aws_security_group" "ec2-auto-sg" {
  name        = "ec2-auto-sg"
  description = "allow all ec2"
  vpc_id      = aws_vpc.webserver_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg"
  }
}

resource "aws_launch_configuration" "lunch-config" {
  name          = "config-ecs"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  lifecycle {
    create_before_destroy = true
  }
  iam_instance_profile        = aws_iam_instance_profile.project_profile.name
  key_name                    = var.key_name
  security_groups             = [aws_security_group.ec2-auto-sg.id]
  associate_public_ip_address = true
  user_data                   = <<EOF
#! /bin/bash
sudo apt-get update
sudo echo "ECS_CLUSTER= web-cluster" >> /etc/ecs/ecs.config
EOF
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "ecs_asg"
  launch_configuration      = aws_launch_configuration.lunch-config.name
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 2
  health_check_type         = "EC2"
  health_check_grace_period = 300
  vpc_zone_identifier       = [aws_subnet.webserver_public_subnet1.id, aws_subnet.webserver_public_subnet2.id]

  target_group_arns     = [aws_alb_target_group.alb_target_group.arn]
  protect_from_scale_in = true
  lifecycle {
    create_before_destroy = true
  }
}
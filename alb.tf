# APPLICATION LOAD BALANCER FILE

# SECURITY GROUP FOR LOAD BALANCER
resource "aws_security_group" "lb" {
    name   = "allow-all-lb_traffic"
  vpc_id = aws_vpc.webserver_vpc.id
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
}
# terraform create application load balancer

# APPLICATION LOAD BALANCER

resource "aws_lb" "web-alb" {
  name = "web-alb"
  internal = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id, aws_security_group.vpc-security-group.id]

  enable_deletion_protection = false

    subnet_mapping {
    subnet_id     = aws_subnet.webserver_public_subnet1.id
  }

  subnet_mapping {
    subnet_id     = aws_subnet.webserver_public_subnet2.id
  }

  tags = {
    name = "web-alb"
  }
}

# TARGET GROUP

resource "aws_alb_target_group" "alb_target_group" {
  name        = "alb-tg"
  target_type = "instance"
  protocol    = "HTTP"
  port        = "80"
  vpc_id      = aws_vpc.webserver_vpc.id

  health_check {
    healthy_threshold   = 5
    interval            = 100
    matcher             = "200,301,302"
    path                = "/"
    timeout             = 50
    unhealthy_threshold = 2
  }
}

# LISTENER ON PORT 80 WITH REDIRECT APPLICATION

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    type             = "forward"
  }
}
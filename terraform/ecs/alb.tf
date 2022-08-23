resource "aws_lb" "this" {
  name               = "demo-alb-for-ecs"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.nginx-demo-sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true


  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "this" {
  name        = "demo-tf-lb-for-ecs"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.this.id
  
  health_check {
    path = "/"
    healthy_threshold = 3
    interval = 20
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
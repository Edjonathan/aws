resource "aws_launch_configuration" "ecs_launch_config" {
  associate_public_ip_address = true
  image_id                    = "ami-090fa75af13c156b4"
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  security_groups             = [aws_security_group.this.id]
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER=cluster-demo >> /etc/ecs/ecs.config"
  instance_type               = "t2.micro"
}

resource "aws_autoscaling_group" "this" {
  name                 = "asg"
  vpc_zone_identifier  = [for subnet in aws_subnet.public : subnet.id]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name
  #protect_from_scale_in     = true
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  target_group_arns         = [aws_lb_target_group.this.arn]
}
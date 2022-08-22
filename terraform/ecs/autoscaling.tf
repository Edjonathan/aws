resource "aws_launch_configuration" "ecs_launch_config" {
    image_id             = "ami-090fa75af13c156b4"
    iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
    security_groups      = [aws_security_group.this.id]
    user_data            = "#!/bin/bash\necho ECS_CLUSTER=cluster-demo >> /etc/ecs/ecs.config"
    instance_type        = "t2.micro"
}

resource "aws_autoscaling_group" "this" {
    name                      = "asg"
    vpc_zone_identifier       = [aws_subnet.public[0].id, aws_subnet.public[1].id, aws_subnet.public[2].id]
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name
    protect_from_scale_in     = true
    desired_capacity          = 2
    min_size                  = 1
    max_size                  = 10
    health_check_grace_period = 300
    health_check_type         = "EC2"
}
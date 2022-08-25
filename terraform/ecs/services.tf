resource "aws_ecs_service" "this" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 2

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "ecs-nginx-container"
    container_port   = 8080
  }
  network_configuration {
    subnets          = [for subnet in aws_subnet.public : subnet.id]
    security_groups  = [aws_security_group.nginx-demo-sg.id]
  }
}
terraform {
  required_version = "1.2.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.18.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  #Not Recommended
  #access_key =
  ##secret_key = 
  profile = var.aws_profile
}

# resource "aws_ecs_cluster" "this" {
#   name = "cluster-demo"

#   setting {
#     name  = "containerInsights"
#     value = "enabled"
#   }
# }

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = "cluster-demo"
  capacity_providers = ["FARGATE", "FARGATE_SPOT", aws_ecs_capacity_provider.this.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_autoscaling_group.this.name
  }
}

resource "aws_ecs_capacity_provider" "this" {
  name = "cluster-demo-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.this.arn
    # managed_termination_protection = local.protect_from_scale_in ? "ENABLED" : "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      # target_capacity           = local.target_capacity
    }
  }
}

# resource "aws_ecs_service" "this" {
#   name            = "hello-world-service"
#   cluster         = aws_ecs_cluster.this.id
#   task_definition = aws_ecs_task_definition.hello_world.arn
#   desired_count   = var.app_count
#   launch_type     = "FARGATE"

#   network_configuration {
#     security_groups = [aws_security_group.this.id]
#     subnets         = aws_subnet.private.*.id
#   }
# }
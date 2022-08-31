resource "aws_ecs_task_definition" "this" {
  family                   = "ecs-nginx-task"
  container_definitions    = file("containerdefinition.json")
  requires_compatibilities = ["EC2"]
  cpu                      = "1024"
  network_mode             = "bridge"
  memory                   = "2048"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  #   ephemeral_storage {
  #     size_in_gib = 21
  #   }
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

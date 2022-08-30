resource "aws_ecs_task_definition" "this" {
  family                   = "ecs-nginx-task"
  container_definitions    = file("containerdefinition.json")
  requires_compatibilities = ["EC2"]
  cpu                      = ".5 vCPU"
  network_mode             = "bridge"
  memory                   = 1024
  #   ephemeral_storage {
  #     size_in_gib = 21
  #   }
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

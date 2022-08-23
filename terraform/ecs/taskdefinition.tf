resource "aws_ecs_task_definition" "this" {
  family                   = "service"
  container_definitions    = file("taskdefinition.json")
  requires_compatibilities = ["EC2"]
  cpu                      = ".5 vCPU"
  memory                   = 1024
  #   ephemeral_storage {
  #     size_in_gib = 21
  #   }
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

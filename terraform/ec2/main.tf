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

data "aws_availability_zones" "this" {
  state = "available"
}

resource "aws_subnet" "public" {
  count                   = 3
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, 2 + count.index)
  availability_zone       = data.aws_availability_zones.this.names[count.index]
  vpc_id                  = aws_vpc.default.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.this.names[count.index]
  vpc_id            = aws_vpc.default.id
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"  
  tags = {
    Name = "vpc-ecs-demo"
  }
}

resource "aws_security_group" "this" {
  name        = "example-alb-security-group"
  vpc_id      = aws_vpc.this.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "this" {
  name = "cluster-demo"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "this" {
  name            = "hello-world-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.hello_world.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.this.id]
    subnets         = aws_subnet.private.*.id
  }
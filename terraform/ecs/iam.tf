data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_instance_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


# Task Role
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_task_policy.json}"
}


resource "aws_iam_role_policy_attachment" "ecs_task_role_attachment" {
   role = "${aws_iam_role.ecs_task_role.name}"
   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


#IAM Profile EC2

resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs-instance-role"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_instance_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
   role = "${aws_iam_role.ecs_instance_role.name}"
   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}
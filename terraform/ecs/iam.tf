data "aws_iam_policy_document" "ecs_task_policy" {
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
   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}



#IAM Profile EC2

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-profile"
  role = aws_iam_role.ecs_task_role.name
}


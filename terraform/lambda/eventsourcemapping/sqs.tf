resource "aws_sqs_queue" "this" {
  name                       = "my-first-sqs-queue-terraform"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400
  delay_seconds              = 90
  max_message_size           = 1024
  tags                       = var.organization_tags
}
resource "aws_lambda_function" "this" {
  function_name    = "my-first-lambda-terraform"
  role             = aws_iam_role.this.arn
  runtime          = "python3.8"
  handler          = "main.lambda_handler"
  filename         = data.archive_file.lambda_zip_inline.output_path
  source_code_hash = data.archive_file.lambda_zip_inline.output_base64sha256
  tags             = var.organization_tags
}

data "archive_file" "lambda_zip_inline" {
  type        = "zip"
  output_path = "/tmp/lambda_zip_inline.zip"
  source {
    filename = "main.py"
    content  = <<EOF
import os

def lambda_handler(event, context):
 message = 'Hello {} {}!'.format(event['first_name'], event['last_name'])
 print(event)
 return {
 'message' : message
 }
EOF  
  }
}
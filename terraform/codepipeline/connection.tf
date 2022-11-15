resource "aws_codestarconnections_connection" "this" {
  name          = "example-connection"
  provider_type = "GitHub"
}
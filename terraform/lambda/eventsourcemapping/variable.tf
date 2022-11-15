variable "aws_region" {
  type        = string
  description = ""
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = ""
  default     = "terraform"
}


variable "organization_tags" {
  type        = map(string)
  description = ""
  default = {
    name    = "Ubuntu"
    project = "Terraform"
  }
}
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

variable "instance_ami" {
  type        = string
  description = ""
  default     = "ami-0022f774911c1d690"
}

variable "instamce_type" {
  type        = string
  description = ""
  default     = "t2.micro"
}

variable "instance_tags" {
  type        = map(string)
  description = ""
  default = {
    name    = "Ubuntu"
    project = "Terraform"
  }
}
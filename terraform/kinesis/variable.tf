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

variable "s3_bucket_name" {
    type = string
    description = "Bucket demo kinesis firehose"
    default = "demo-bucket-edjonathan-kinesis"
}

variable "instance_tags" {
  type        = map(string)
  description = ""
  default = {
    name    = "Ubuntu"
    project = "Terraform"
  }
}
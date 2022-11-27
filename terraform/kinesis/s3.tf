resource "aws_s3_bucket" "example" {
  bucket = var.s3_bucket_name
  
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    effect = "Allow"
    resources = [
      aws_s3_bucket.example.arn,
      "${var.s3_bucket_name}/*",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::904935406762:root","arn:aws:iam::904935406762:user/gedjona-admin"]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
  }
}
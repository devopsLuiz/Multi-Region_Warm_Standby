resource "aws_s3_bucket" "frontend_primary" {
  bucket = "myapp-frontend-primary-us-east-1"
}

resource "aws_s3_bucket" "frontend_secondary" {
  provider = aws.us_east_2
  bucket   = "myapp-frontend-secondary-us-east-2"
}

resource "aws_s3_bucket_policy" "frontend_policy-us-east-1" {
  bucket = aws_s3_bucket.frontend_primary.id
  policy = data.aws_iam_policy_document.frontend_bucket_policy.json
  depends_on [aws_s3_bucket.frontend_primary]
}


resource "aws_s3_bucket_policy" "frontend_policy-us-east-2" {
  bucket = aws_s3_bucket.frontend_primary.id
  policy = data.aws_iam_policy_document.frontend_bucket_policy.json
  depends_on [aws_s3_bucket.frontend_secondary]
}

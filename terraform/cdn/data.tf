data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket         = "remote-tfstate-lock"
    key            = "state/network/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "compute" {
  backend = "s3"

  config = {
    bucket         = "remote-tfstate-lock"
    key            = "state/compute/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "storage" {
  backend = "s3"

  config = {
    bucket         = "remote-tfstate-lock"
    key            = "state/storage/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ec2_managed_prefix_list" "cloudfront" {
  filter {
    name   = "prefix-list-name"
    values = ["com.amazonaws.global.cloudfront.origin-facing"]
  }
}

data "aws_iam_policy_document" "frontend_bucket_policy-us-east-1" {
  statement {
    sid    = "AllowCloudFrontRead"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.frontend_primary.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        aws_cloudfront_distribution.app_frontend_cdn.arn
      ]
    }
  }
}




data "aws_iam_policy_document" "frontend_bucket_policy-us-east-2" {
  statement {
    sid    = "AllowCloudFrontRead"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.frontend_secondary.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        aws_cloudfront_distribution.app_frontend_cdn.arn
      ]
    }
  }
}
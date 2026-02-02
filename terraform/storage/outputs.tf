output "bucket_name-us-east-1"{

    value = aws_s3_bucket.frontend_primary.bucket_regional_domain_name
}

output "bucket_arn-us-east-1"{

    value = aws_s3_bucket.frontend_primary.arn
}


output "bucket_name-us-east-2"{

    value = aws_s3_bucket.frontend_secondary.bucket_regional_domain_name
}


output "bucket_arn-us-east-2"{

    value = aws_s3_bucket.frontend_secondary.arn
}


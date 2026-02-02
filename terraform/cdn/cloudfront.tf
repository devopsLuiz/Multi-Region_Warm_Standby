
resource "aws_cloudfront_origin_access_control" "frontend_oac" {
  name                              = "frontend-mrap-oac"
  description                       = "OAC for S3 MRAP frontend"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "app_frontend_cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for frontend (S3 multi-region)"
  price_class         = "PriceClass_All"
  default_root_object = "index.html"

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  origin {
    domain_name              = data.terraform_remote_state.storage.outputs.Bucket_frontend-us-east-1
    origin_id                = "s3-frontend-us-east-1"
    origin_access_control_id = aws_cloudfront_origin_access_control.frontend_oac.id
  }

  origin {
    domain_name              = data.terraform_remote_state.storage.outputs.Bucket_frontend-us-east-2
    origin_id                = "s3-frontend-us-east-2"
    origin_access_control_id = aws_cloudfront_origin_access_control.frontend_oac.id
  }

  origin_group {
    origin_id = "frontend-origin-group"

    failover_criteria {
      status_codes = [403, 404]
    }

    member {
      origin_id = "s3-frontend-us-east-1"
    }

    member {
      origin_id = "s3-frontend-us-east-2"
    }
  }

  default_cache_behavior {
    target_origin_id       = "frontend-origin-group"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      headers      = []

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name        = "app-frontend-cdn"
    Environment = "production"
  }
}





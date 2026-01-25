resource "aws_cloudfront_distribution" "ecs_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ECS application"
  default_root_object = ""

  origin {
    
    domain_name = data.terraform_remote_state.compute.outputs.alb_dns_name
    origin_id   = "ecs-alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
      origin_read_timeout    = 60
      origin_keepalive_timeout = 5
    }

    custom_header {
      name  = "X-Custom-Header"
      value = "CloudFrontOrigin"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ecs-alb-origin"

    forwarded_values {
      query_string = true
      headers      = ["Host", "Accept", "Accept-Language", "Authorization"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
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
    Name = "ecs-cloudfront-distribution"
  }
}


resource "aws_security_group_rule" "alb_from_cloudfront" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.cloudfront.id]
  security_group_id = data.terraform_remote_state.network.outputs.security_groups-us-east-1
  description       = "Allow CloudFront to ALB"
}




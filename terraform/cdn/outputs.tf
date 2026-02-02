output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.app_frontend_cdn.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.app_frontend_cdn.domain_name
}

output "cloudfront_hosted_zone_id" {
  value = aws_cloudfront_distribution.app_frontend_cdn.hosted_zone_id
}

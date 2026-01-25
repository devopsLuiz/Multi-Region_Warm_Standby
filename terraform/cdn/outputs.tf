output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.ecs_distribution.domain_name
  description = "CloudFront distribution domain name"
}

output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.ecs_distribution.id
  description = "CloudFront distribution ID"
}
output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.ecs_alb-us-east-1.dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.ecs_alb-us-east-1.arn
}

output "alb_zone_id" {
  description = "Zone ID of the ALB"
  value       = aws_lb.ecs_alb-us-east-1.zone_id
}
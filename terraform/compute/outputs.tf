output "alb_dns_name-us-east-1" {
  description = "DNS name of the ALB"
  value       = aws_lb.ecs_alb-us-east-1.dns_name
}

output "alb_arn-us-east-1" {
  description = "ARN of the ALB"
  value       = aws_lb.ecs_alb-us-east-1.arn
}

output "alb_zone_id-us-east-1" {
  description = "Zone ID of the ALB"
  value       = aws_lb.ecs_alb-us-east-1.zone_id
}

output "alb_dns_name-us-east-2" {
  description = "DNS name of the ALB"
  value       = aws_lb.ecs_alb-us-east-2.dns_name
}

output "alb_arn-us-east-2" {
  description = "ARN of the ALB"
  value       = aws_lb.ecs_alb-us-east-2.arn
}

output "alb_zone_id-us-east-2" {
  description = "Zone ID of the ALB"
  value       = aws_lb.ecs_alb-us-east-2.zone_id
}
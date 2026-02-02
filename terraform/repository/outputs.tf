output "ECR_repository_us-east-1" {

    value = aws_ecr_repository.app_repo-us-east-1.repository_url
}

output "ECR_repository_us-east-2" {

        value = aws_ecr_repository.app_repo-us-east-2.repository_url
}
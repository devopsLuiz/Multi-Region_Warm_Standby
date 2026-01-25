resource "aws_ecr_repository" "app_repo-us-east-1" {
  name                 = "app_repo"
  image_tag_mutability = "MUTABLE"  # or "IMMUTABLE" based on your requirement
  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecr_lifecycle_policy" "repo_policy-us-east-1" {
  repository = aws_ecr_repository.app_repo-us-east-1.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description   = "Keep only 10 images"
        selection     = {

          tagStatus   = "any"
          countType  = "imageCountMoreThan"
          countNumber = 10

        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}



# ---------------------------------- us-east-2 -------------------------------------


resource "aws_ecr_repository" "app_repo-us-east-2" {

  provider = aws.us_east_2
  name                 = "app_repo"
  image_tag_mutability = "MUTABLE"  # or "IMMUTABLE" based on your requirement
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "repo_policy-us-east-2" {
  repository = aws_ecr_repository.app_repo-us-east-2.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description   = "Keep only 10 images"
        selection     = {
          
          tagStatus   = "any"
          countType  = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
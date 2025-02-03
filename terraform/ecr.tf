# ecr.tf

#####################################
# Amazon ECR Repository
#####################################

resource "aws_ecr_repository" "go_app_repository" {
  name                 = "go-app-repository-${var.environment}"  # Unique per environment
  image_tag_mutability = "MUTABLE"  # Allow image tags to be overwritten

  tags = {
    Environment = var.environment
  }
}

#####################################
# ECR Lifecycle Policy
#####################################

resource "aws_ecr_lifecycle_policy" "go_app_lifecycle_policy" {
  repository = aws_ecr_repository.go_app_repository.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 10,
      "description": "Retain only the latest 10 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

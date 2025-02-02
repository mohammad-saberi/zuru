# iam_ci_cd.tf

#####################################
# IAM Role for CI/CD Pipeline
#####################################

resource "aws_iam_role" "ci_cd_role" {
  name               = "ciCdRole-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ci_cd_assume_role_policy.json
}

# Add permissions for ECR login and ECS deployment
resource "aws_iam_role_policy" "ci_cd_ecr_ecs_policy" {
  name   = "ciCdECRECSPolicy-${var.environment}"
  role   = aws_iam_role.ci_cd_role.id
  policy = data.aws_iam_policy_document.ci_cd_ecr_ecs_policy_document.json
}

data "aws_iam_policy_document" "ci_cd_ecr_ecs_policy_document" {
  # Allow ECR login
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"  # Critical for Docker login
    ]
    resources = ["*"]
  }

  # Allow pushing images to ECR
  statement {
    effect = "Allow"
    actions = [
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage"
    ]
    resources = [aws_ecr_repository.go_app_repository.arn]
  }

  # Allow ECS deployment
  statement {
    effect = "Allow"
    actions = [
      "ecs:UpdateService",
      "ecs:DescribeServices",
      "ecs:RegisterTaskDefinition"
    ]
    resources = ["*"]
  }
}
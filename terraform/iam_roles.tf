# iam_roles.tf

#####################################
# IAM Role for ECS Task Execution
#####################################

# ECS Task Execution Role allows ECS tasks to pull images and send logs
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole-${var.environment}"
  
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role_assume_policy.json
}

data "aws_iam_policy_document" "ecs_task_execution_role_assume_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# Custom policy for ECS Task Execution Role
resource "aws_iam_policy" "ecs_task_execution_policy" {
  name        = "ecsTaskExecutionPolicy-${var.environment}"
  description = "Custom policy for ECS Task Execution Role"

  policy = data.aws_iam_policy_document.ecs_task_execution_policy_document.json
}

data "aws_iam_policy_document" "ecs_task_execution_policy_document" {
  statement {
    sid    = "AllowECRAccess"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage"
    ]
    resources = [
      aws_ecr_repository.go_app_repository.arn,
      "${aws_ecr_repository.go_app_repository.arn}/*"
    ]
  }

  statement {
    sid    = "AllowCloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.ecs_log_group.arn}:*"
    ]
  }
}

# Attach the custom policy to the ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}

#####################################
# IAM Role for ECS Task (Application)
#####################################

# ECS Task Role assumed by the application container
resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole-${var.environment}"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_role_assume_policy.json
}

data "aws_iam_policy_document" "ecs_task_role_assume_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}



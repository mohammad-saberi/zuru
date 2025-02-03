# ecs_task_definition.tf

#####################################
# ECS Task Definition
#####################################

resource "aws_ecs_task_definition" "go_app_task" {
  family                   = "go-app-task-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]                     # Use Fargate launch type
  cpu                      = "512"                           # CPU units
  memory                   = "1024"                          # Memory in MiB
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn  # Application IAM role

  container_definitions = jsonencode([
    {
      name      = "go-app-container"
      image     = "${aws_ecr_repository.go_app_repository.repository_url}:${var.image_tag}"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Environment = var.environment
  }
}

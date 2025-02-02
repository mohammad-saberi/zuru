# cloudwatch_logs.tf

#####################################
# CloudWatch Log Group for ECS Tasks
#####################################

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/go-app-${var.environment}"
  retention_in_days = 7  # Retain logs for 7 days

  tags = {
    Environment = var.environment
  }
}

# ecs_service.tf

#####################################
# ECS Service
#####################################

resource "aws_ecs_service" "go_app_service" {
  name            = "go-app-service-${var.environment}"
  cluster         = aws_ecs_cluster.go_app_cluster.id
  task_definition = aws_ecs_task_definition.go_app_task.arn
  desired_count   = 1                                      # Number of tasks to run
  launch_type     = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets          = var.subnet_ids                      # Subnets for ECS tasks
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
    assign_public_ip = false                               # Do not assign public IP
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.go_app_tg.arn
    container_name   = "go-app-container"
    container_port   = 8080
  }

  deployment_controller {
    type = "ECS"
  }

  # Ensures the ALB listener is created before the ECS service
  depends_on = [aws_lb_listener.http_listener]

  tags = {
    Environment = var.environment
  }
}
# Autoscaling policy to the ECS service for production environment
resource "aws_appautoscaling_target" "ecs_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.go_app_cluster.name}/${aws_ecs_service.go_app_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 1
  max_capacity       = 3
}

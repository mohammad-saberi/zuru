# alb.tf

#####################################
# Application Load Balancer (ALB)
#####################################

resource "aws_lb" "go_app_alb" {
  name               = "go-app-alb-${var.environment}"
  load_balancer_type = "application"
  subnets            = var.subnet_ids                     # Subnets for ALB
  security_groups    = [aws_security_group.alb_sg.id]     # ALB security group

  access_logs {
    bucket  = aws_s3_bucket.alb_log_bucket.id            # S3 bucket for access logs
    prefix  = "alb-logs/${var.environment}/"             # Log file prefix
    enabled = true                                       # Enable access logs
  }

  tags = {
    Environment = var.environment
  }
}

#####################################
# Target Group for ECS Tasks
#####################################

resource "aws_lb_target_group" "go_app_tg" {
  name        = "go-app-tg-${var.environment}"
  port        = 8080                                    # Port the app listens on
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"                                    # Use IP mode for Fargate

  health_check {
    path                = "/health"                     # Health check endpoint
    interval            = 30                            # Check every 30 seconds
    timeout             = 5                             # Timeout after 5 seconds
    healthy_threshold   = 2                             # 2 successful checks to be healthy
    unhealthy_threshold = 2                             # 2 failed checks to be unhealthy
    matcher             = "200"                         # Expected HTTP status code
  }

  tags = {
    Environment = var.environment
  }
}

#####################################
# ALB Listener
#####################################

# HTTP listener (For testing purposes)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.go_app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.go_app_tg.arn
  }
}

# HTTPS listener (Must be used for production)
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.go_app_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.ssl_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.go_app_tg.arn
  }
}

# outputs.tf

#####################################
# Output: ALB DNS Name
#####################################

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = aws_lb.go_app_alb.dns_name
}

#####################################
# Output: ECR Repository URL
#####################################

output "ecr_repository_url" {
  description = "The URL of the ECR repository."
  value       = aws_ecr_repository.go_app_repository.repository_url
}

#####################################
# Output: ECS Cluster Name
#####################################

output "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  value       = aws_ecs_cluster.go_app_cluster.name
}

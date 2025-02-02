# ecs_cluster.tf

#####################################
# ECS Cluster
#####################################

resource "aws_ecs_cluster" "go_app_cluster" {
  name = "go-app-cluster-${var.environment}"

  tags = {
    Environment = var.environment
  }
}

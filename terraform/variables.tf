# variables.tf

# AWS region where resources will be deployed
variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

# AWS Account ID
variable "aws_account_id" {
  description = "AWS account ID."
  type        = string
}

# AWS Account ID
variable "aws_access_key_id" {
  description = "AWS Access Key ID."
  type        = string
}

# AWS Account ID
variable "aws_secret_access_key" {
  description = "AWS Access Key."
  type        = string
}

# Docker image tag for deployment
variable "image_tag" {
  description = "Docker image tag to deploy."
  type        = string
}

# VPC ID where resources will be deployed
variable "vpc_id" {
  description = "The VPC ID for deploying resources."
  type        = string
}

# List of subnet IDs for ECS tasks and ALB
variable "subnet_ids" {
  description = "List of subnet IDs for ECS tasks and ALB."
  type        = list(string)
}

# Deployment environment (e.g., development, production)
variable "environment" {
  description = "Deployment environment (development or production)."
  type        = string
}

# SSL certificate ARN for HTTPS listener
variable "ssl_certificate_arn" {
  description = "SSL certificate ARN for HTTPS listener."
  type        = string
}
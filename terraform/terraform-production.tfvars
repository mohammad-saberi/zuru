# terraform.tfvars

aws_account_id     = "00nf06i6l4q95nboziy7vt"   # Mock AWS account ID
aws_access_key_id  = "test"                     # Mock AWS access key ID
aws_secret_access_key = "test"                  # Mock AWS Secret access key
aws_region         = "us-east-1"                # Use us-east-1 for LocalStack
vpc_id             = "vpc-12345678"             # Mock VPC ID
subnet_ids         = ["subnet-910111213141516", "subnet-161514131211109"]  # Mock subnet IDs
image_tag          = "production"               # Docker image tag
environment        = "production"               # Deployment environment
ssl_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  # SSL certificate ARN for ALB

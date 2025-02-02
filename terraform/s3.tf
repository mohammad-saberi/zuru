# s3.tf

#####################################
# S3 Bucket for ALB Access Logs
#####################################

# Create an S3 bucket for storing ALB access logs
resource "aws_s3_bucket" "alb_log_bucket" {
  # The bucket name must be globally unique
  bucket = "alb-logs-${var.aws_account_id}-${var.environment}"
  
  # Optional: Enable versioning for enhanced data protection (not required for log buckets)
  # versioning {
  #   enabled = true
  # }

  tags = {
    Environment = var.environment
  }
}

#####################################
# S3 Bucket ACL
#####################################

# Define the ACL for the S3 bucket using the 'aws_s3_bucket_acl' resource
resource "aws_s3_bucket_acl" "alb_log_bucket_acl" {
  bucket = aws_s3_bucket.alb_log_bucket.id
  acl    = "private"
}

#####################################
# S3 Bucket Policy for ALB Logging
#####################################

# Allow the ALB service to write logs to the S3 bucket
resource "aws_s3_bucket_policy" "alb_log_bucket_policy" {
  bucket = aws_s3_bucket.alb_log_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Sid:       "AWSALBAccessLogsPolicy"
        Effect:    "Allow"
        Principal: { Service: "elasticloadbalancing.amazonaws.com" }
        Action:    "s3:PutObject"
        Resource:  "${aws_s3_bucket.alb_log_bucket.arn}/*"
        Condition: {
          StringEquals: {
            "aws:SourceAccount": "${var.aws_account_id}"
          }
          ArnLike: {
            "aws:SourceArn": "arn:aws:elasticloadbalancing:${var.aws_region}:${var.aws_account_id}:loadbalancer/*"
          }
        }
      }
    ]
  })
}

#####################################
# S3 Bucket Lifecycle Configuration
#####################################

# Set a lifecycle policy to manage log file retention
resource "aws_s3_bucket_lifecycle_configuration" "alb_log_bucket_lifecycle" {
  bucket = aws_s3_bucket.alb_log_bucket.id

  rule {
    id     = "ExpireALBLogs"
    status = "Enabled"

    filter {
      prefix = "alb-logs/${var.environment}/"
    }

    expiration {
      days = 30  # Retain logs for 30 days
    }
  }
}

#####################################
# S3 Bucket Public Access Block
#####################################

# Prevent public access to ensure data security
resource "aws_s3_bucket_public_access_block" "alb_log_bucket_public_access" {
  bucket = aws_s3_bucket.alb_log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#####################################
# S3 Bucket Encryption
#####################################

# Enable server-side encryption for the S3 bucket

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_log_bucket_encryption" {
  bucket = aws_s3_bucket.alb_log_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_wafv2_ip_set" "allowed_ips" {
  name               = "IaC-allowed-IPs-${var.environment}"
  description        = "Allowed IPs for ECS service"
  scope              = "REGIONAL" # For ALB; use CLOUDFRONT if attached to CloudFront
  ip_address_version = "IPV4"

  addresses = [
    "190.138.88.251/32", # Leo #1
    "186.130.89.187/32", # Leo #2
    "72.218.190.94/32",  # Jason Ebbers
    "102.187.25.76/32", # Ali
    "104.244.227.182/32", # Bavin
    "76.65.152.19/32", # Cherif
    "67.175.238.122/32", # Tony
    "47.6.115.15/32", # Chasen
    "104.28.123.86/32", # Chasen #2
    "179.193.36.234/32", # Lucas
    "136.60.161.194/32", # Greg Koenig
    "50.223.169.130/32", # Jeremiah
    "73.46.166.192/32", # Jeremiah Home
    "69.248.178.62/32", # SR
  ]
}

resource "aws_wafv2_rule_group" "ecs_rule_group" {
  name        = "ECS-allowlist-rules-${var.environment}"
  scope       = "REGIONAL"
  description = "Rule group with IP allowlist for ECS service"
  capacity    = 10

  rule {
    name     = "allow-specific-ips"
    priority = 1

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.allowed_ips.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "allow-specific-ips"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "block-all-other-traffic"
    priority = 2

    action {
      block {}
    }

    statement {
      not_statement {
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.allowed_ips.arn
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "block-all-other-traffic"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ecs-rule-group"
    sampled_requests_enabled   = true
  }
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g. staging, production)"
  type        = string
}

resource "aws_wafv2_ip_set" "allowed_ips" {
  name               = "IaC-allowed-IPs-${var.environment}"
  description        = "Allowed IPs for ECS service"
  scope              = "REGIONAL" # For ALB; use CLOUDFRONT if attached to CloudFront
  ip_address_version = "IPV4"

  addresses = [
    "190.138.88.251/32", # Leo's home
    "186.130.107.46/32", # Leo's home 2
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
resource "aws_wafv2_ip_set" "allowed_ips" {
  name               = "IaC-allowed-IPs"
  description        = "Allowed IPs for ECS service"
  scope              = "REGIONAL" # For ALB; use CLOUDFRONT if attached to CloudFront
  ip_address_version = "IPV4"

  addresses = [
    "190.138.88.251/32", # Leo's home
    "186.130.107.46/32", # Leo's home 2
  ]
}

resource "aws_wafv2_web_acl" "ecs_waf" {
  name        = "ecs-allowlist"
  scope       = "REGIONAL"
  description = "Allow only certain IPs to access ECS ALB"

  default_action {
    block {}
  }

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

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ecs-waf"
    sampled_requests_enabled   = true
  }
}
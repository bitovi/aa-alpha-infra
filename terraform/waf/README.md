# WAF Rules Documentation

## Overview

This Terraform module creates AWS WAF v2 resources for IP allowlisting:

- **IP Set**: Defines allowed IP addresses
- **Rule Group**: Contains rules for allowing specific IPs and blocking all others

## Components

### IP Set (`aws_wafv2_ip_set.allowed_ips`)
- Contains the list of allowed IP addresses in CIDR notation
- Scoped for REGIONAL use (ALB/API Gateway)

### Rule Group (`aws_wafv2_rule_group.ecs_rule_group`)
- **Rule 1**: Allows traffic from IPs in the allowed IP set (Priority 1)
- **Rule 2**: Blocks all other traffic not in the allowed IP set (Priority 2)

## Managing IP Addresses

1. Edit `terraform/waf/rules.tf`
2. Add the new IP address to the `addresses` list in the `aws_wafv2_ip_set` resource:

```terraform
addresses = [
  "190.138.88.251/32", # Existing IP
  "186.130.107.46/32", # Existing IP
  "192.168.1.100/32",  # New IP to add
]
```

3. Run the WAF workflow in GitHub Actions or apply via Terraform CLI

## CIDR Notation Examples

- Single IP: `192.168.1.100/32`
- IP range: `192.168.1.0/24` (entire subnet)
- Larger range: `10.0.0.0/16`

## Deployment

Use the GitHub Actions workflow `.github/workflows/waf-rules-tf.yaml` to deploy changes:

1. Go to Actions tab in GitHub
2. Select "WAF Rule Management" workflow
3. Choose environment and action (create/destroy)
4. Run workflow
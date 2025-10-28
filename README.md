
# aa-alpha-infra

Infrastructure repository for AA Alpha project.

## Overview


This repository contains infrastructure-as-code and automation for managing AWS resources for the AA Alpha project. It leverages GitHub Actions workflows and Terraform to provision and manage:

- **Amazon ECR (Elastic Container Registry)**
- **Amazon RDS (Relational Database Service)**
- **IAM roles and policies for ECS (via Terraform)**
- **WAF rules for IP allowlisting (via Terraform)**


## GitHub Actions Workflows

### ECR Management Workflow
Located at `.github/workflows/ecr-deploy.yml`.

Provisions and manages ECR registries for different environments (`development`, `staging`, `production`). Uses the [bitovi/github-actions-deploy-aws-ecr-registry](https://github.com/bitovi/github-actions-deploy-aws-ecr-registry/) action.

**Inputs:**
- `environment`: Target environment (required)
- `tf_stack_destroy`: Optionally destroy the Terraform stack

**AWS resources managed:**
- ECR registry named `aa-alpha-registry-<environment>`

### RDS Management Workflow
Located at `.github/workflows/rds-deploy.yml`.

Provisions and manages RDS databases for different environments. Uses the [bitovi/github-actions-deploy-rds](https://github.com/bitovi/github-actions-deploy-rds) action.

**Inputs:**
- `environment`: Target environment (required)
- `tf_stack_destroy`: Optionally destroy the Terraform stack

**AWS resources managed:**
- RDS instance named `aa-alpha-db-<environment>`

### IAM Role Management (Terraform)
Located at `.github/workflows/iam-role-tf.yaml`.

Provisions and manages IAM roles and policies for ECS using Terraform. This includes:
- ECS task execution role (unique per environment)
- Custom Secrets Manager policy for ECS

**Inputs:**
- `action`: `create` or `destroy` (required)
- `environment`: Target environment (required)

**AWS resources managed:**
- IAM roles and policies for ECS task execution and secrets access

### WAF Rules Management (Terraform)
Located at `.github/workflows/waf-rules-tf.yaml`.

Provisions and manages WAF rule groups for IP allowlisting using Terraform. This includes:
- IP set with allowed IP addresses
- Rule group with allow/block rules

**Inputs:**
- `action`: `create` or `destroy` (required)
- `environment`: Target environment (required)

**AWS resources managed:**
- WAF IP sets and rule groups for traffic filtering

### Wichita Bucket Management
Located at `.github/workflows/wichita-bucket.yaml`.

Provisions and manages an S3 bucket for Wichita transformed data across different environments.

**Inputs:**
- `action`: `create` or `destroy` (required)
- `environment`: Target environment (required)

**AWS resources managed:**
- S3 bucket named `wichita-myga-file-<environment>`


## Getting Started

1. Fork or clone this repository.
2. Configure AWS credentials and region as GitHub secrets/variables.
3. Trigger workflows via GitHub Actions UI or API.
4. For IAM/terraform: see `terraform/iam/iam.tf` for variable usage and customization.
5. For WAF/terraform: see `terraform/waf/rules.tf` for variable usage and customization.


## Repository Structure

- `.github/workflows/` — Contains GitHub Actions workflow files for ECR, RDS, IAM, and WAF (Terraform) management.
- `terraform/iam/` — Terraform code for IAM roles and policies for ECS. See [IAM Documentation](terraform/iam/README.md).
- `terraform/waf/` — Terraform code for WAF IP allowlisting rules. See [WAF Documentation](terraform/waf/README.md).
- `README.md` — Project documentation.

## Detailed Documentation

- **[IAM Roles & Permissions](terraform/iam/README.md)** - Detailed explanation of ECS IAM roles, permissions, and security practices
- **[WAF Rules & IP Management](terraform/waf/README.md)** - Guide for managing IP allowlists and WAF rule groups

## Maintainers

Bitovi DevOps Team
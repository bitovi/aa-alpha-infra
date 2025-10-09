
# aa-alpha-infra

Infrastructure repository for AA Alpha project.

## Overview


This repository contains infrastructure-as-code and automation for managing AWS resources for the AA Alpha project. It leverages GitHub Actions workflows and Terraform to provision and manage:

- **Amazon ECR (Elastic Container Registry)**
- **Amazon RDS (Relational Database Service)**
- **IAM roles and policies for ECS (via Terraform)**


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


## Getting Started

1. Fork or clone this repository.
2. Configure AWS credentials and region as GitHub secrets/variables.
3. Trigger workflows via GitHub Actions UI or API.
4. For IAM/terraform: see `terraform/iam/iam.tf` for variable usage and customization.
5. For IAM/terraform: see `terraform/waf-acl/acl.tf` for variable usage and customization.


## Repository Structure

- `.github/workflows/` — Contains GitHub Actions workflow files for ECR, RDS, and IAM (Terraform) management.
- `terraform/iam/` — Terraform code for IAM roles and policies for ECS.
- `terraform/waf-acl/` — Terraform code for WAF IP Allowlist.
- `README.md` — Project documentation.

## Maintainers

Bitovi DevOps Team
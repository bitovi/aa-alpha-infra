
# aa-alpha-infra

Infrastructure repository for AA Alpha project.

## Overview

This repository contains infrastructure-as-code and automation for managing AWS resources for the AA Alpha project. It leverages GitHub Actions workflows to provision and manage:

- **Amazon ECR (Elastic Container Registry)**
- **Amazon RDS (Relational Database Service)**

## GitHub Actions Workflows

### ECR Management Workflow

Located at `.github/workflows/ecr-deploy.yml`.

This workflow provisions and manages ECR registries for different environments (`development`, `staging`, `production`). It uses the [bitovi/github-actions-deploy-aws-ecr-registry](https://github.com/bitovi/github-actions-deploy-aws-ecr-registry/) action.

**Inputs:**
- `environment`: Target environment (required)
- `tf_stack_destroy`: Optionally destroy the Terraform stack

**AWS resources managed:**
- ECR registry named `aa-alpha-registry-<environment>`

### RDS Management Workflow

Located at `.github/workflows/rds-deploy.yml`.

This workflow provisions and manages RDS databases for different environments. It uses the [bitovi/github-actions-deploy-rds](https://github.com/bitovi/github-actions-deploy-rds) action.

**Inputs:**
- `environment`: Target environment (required)
- `tf_stack_destroy`: Optionally destroy the Terraform stack

**AWS resources managed:**
- RDS instance named `aa-alpha-db-<environment>`

## Getting Started

1. Fork or clone this repository.
2. Configure AWS credentials and region as GitHub secrets/variables.
3. Trigger workflows via GitHub Actions UI or API.

## Repository Structure

- `.github/workflows/` — Contains GitHub Actions workflow files for ECR and RDS management.
- `README.md` — Project documentation.

## Maintainers

Bitovi DevOps Team
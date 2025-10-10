# IAM Roles Documentation

## Overview

This Terraform module creates IAM roles and policies for ECS tasks to securely access AWS services:

- **ECS Task Execution Role**: Used by ECS to manage tasks (pull images, write logs, access secrets)
- **ECS Task Role**: Used by the application running inside containers
- **Custom Secrets Policy**: Grants access to specific secrets in AWS Secrets Manager

## Resources Created

### ECS Task Execution Role (`aws_iam_role.ecs_task_execution_role`)

**Purpose**: This role is used by the ECS service itself to:
- Pull container images from Amazon ECR
- Send logs to CloudWatch Logs
- Retrieve secrets and configuration from AWS Secrets Manager/SSM

**Permissions**:
- `AmazonECSTaskExecutionRolePolicy` (AWS managed policy)
  - ECR image pulling (`ecr:GetAuthorizationToken`, `ecr:BatchCheckLayerAvailability`, etc.)
  - CloudWatch Logs writing (`logs:CreateLogGroup`, `logs:CreateLogStream`, `logs:PutLogEvents`)
  - Basic ECS task management
- Custom Secrets Manager policy (see below)

### ECS Task Role (`aws_iam_role.ecs_task_role`)

**Purpose**: This role is used by the application code running inside the container to access AWS services.

### Custom Secrets Manager Policy (`aws_iam_policy.ecs_task_execution_secrets_policy`)

**Purpose**: Grants the ECS task execution role access to specific secrets needed by the application.

**Allowed Secrets**:
- `INDEX_STANDARD_API_KEY`
- `DATABASE_URL`
- `CANNEX_SOAP_PASSWORD`
- `CANNEX_SOAP_USERNAME`
- `CANNEX_PROD_SOAP_PASSWORD`
- `CANNEX_PROD_SOAP_USERNAME`
- `TEMPORAL_CLOUD_API_KEY`
- `CANNEX_FTP_USER`
- `CANNEX_FTP_PASSWORD`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `CLERK_SECRET_KEY`
- `CLERK_PUBLISHABLE_KEY`

## Security Best Practices

### Principle of Least Privilege
- Each role only has the minimum permissions needed
- Secrets access is limited to specific secret names
- Region-scoped where possible

### Environment Separation
- Role names include environment suffix (`-staging`, `-production`)
- Separate roles per environment prevent cross-environment access

### Secret Management
- Secrets are referenced by ECS task definitions using `valueFrom` with secret ARNs
- No secrets are hardcoded in container images or task definitions

## Usage in ECS Task Definitions

```json
{
  "executionRoleArn": "arn:aws:iam::ACCOUNT:role/aa-ecs-task-execution-role-staging",
  "taskRoleArn": "arn:aws:iam::ACCOUNT:role/aa-ecs-task-role-staging",
  "containerDefinitions": [
    {
      "secrets": [
        {
          "name": "DATABASE_URL",
          "valueFrom": "arn:aws:secretsmanager:us-east-1:ACCOUNT:secret:DATABASE_URL"
        }
      ]
    }
  ]
}
```

## Adding New Secrets

1. Add the secret name to the `Resource` list in `iam.tf`
2. Update this documentation
3. Apply changes via the IAM workflow

## Variables

- `aws_region`: AWS region for resources (default: us-east-1)
- `environment`: Environment name for resource naming

## Deployment

Use the GitHub Actions workflow `.github/workflows/iam-role-tf.yaml` to deploy changes.
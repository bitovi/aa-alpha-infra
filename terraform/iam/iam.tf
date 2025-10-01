
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g. staging, production)"
  type        = string
}

# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "aa-ecs-task-execution-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Custom Secrets Manager Policy
resource "aws_iam_policy" "ecs_task_execution_secrets_policy" {
  name        = "aa-ecs-task-execution-secrets-policy-${var.environment}"
  description = "Allow ECS tasks to read secrets from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = [
          "arn:aws:secretsmanager:us-east-1:*:secret:INDEX_STANDARD_API_KEY*",
          "arn:aws:secretsmanager:us-east-1:*:secret:DATABASE_URL*",
          "arn:aws:secretsmanager:us-east-1:*:secret:CANNEX_SOAP_PASSWORD*",
          "arn:aws:secretsmanager:us-east-1:*:secret:CANNEX_SOAP_USERNAME*",
          "arn:aws:secretsmanager:us-east-1:*:secret:CANNEX_PROD_SOAP_PASSWORD*",
          "arn:aws:secretsmanager:us-east-1:*:secret:CANNEX_PROD_SOAP_USERNAME*",
          "arn:aws:secretsmanager:us-east-1:*:secret:TEMPORAL_CLOUD_API_KEY*",
          "arn:aws:secretsmanager:us-east-1:*:secret:CANNEX_FTP_USER*",
          "arn:aws:secretsmanager:us-east-1:*:secret:CANNEX_FTP_PASSWORD*",
          "arn:aws:secretsmanager:us-east-1:*:secret:AWS_ACCESS_KEY_ID*",
          "arn:aws:secretsmanager:us-east-1:*:secret:AWS_SECRET_ACCESS_KEY*",
          "arn:aws:secretsmanager:us-east-1:*:secret:CLERK_SECRET_KEY*",
          "arn:aws:secretsmanager:us-east-1:*:secret:CLERK_PUBLISHABLE_KEY*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_secrets" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_secrets_policy.arn
}

terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.12.0"
    }
  }
}

resource "aws_iam_policy" "policy" {
  name        = var.name
  path        = var.path
  description = var.description

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = var.policy

  tags = merge({
    createdBy = "terraform aws-iam/policy"
  }, var.tags)
}

data "aws_caller_identity" "current" {}

terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.12.0"
    }
  }
}

resource "aws_iam_role" "role" {
  name = var.name
  path = var.path

  force_detach_policies = true

  assume_role_policy = var.assume_role_policy
  tags = merge({
    createdBy = "terraform aws-iam/role"
  }, var.tags)
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count      = length(var.policies)
  role       = aws_iam_role.role.name
  policy_arn = var.policies[count.index]
  depends_on = [
    aws_iam_role.role,
  ]
}

data "aws_caller_identity" "current" {}
